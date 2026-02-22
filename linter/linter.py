import json
import subprocess
import sys
import abc

class Colors:
    """Класс для управления цветами в терминале."""
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    END = '\033[0m'

def truncate(text, length=50):
    """Обрезает текст и заменяет переносы строк пробелами."""
    text = text.replace('\n', ' ').strip()
    return (text[:length] + '...') if len(text) > length else text

def extract_text(node):
    """Рекурсивно извлекает текстовое содержимое из структуры данных Typst."""
    if isinstance(node, str):
        return node
    if isinstance(node, dict):
        if node.get('func') == 'text':
            return node.get('text', '')
        if 'children' in node:
            return "".join(extract_text(child) for child in node['children'])
        if 'body' in node:
            return extract_text(node['body'])
    return ""

def get_figure_kind_name(fig):
    """Извлекает название типа фигуры из поля supplement (например, 'Рисунок', 'Таблица')."""
    supplement = fig.get('supplement')
    if supplement:
        return extract_text(supplement).strip()
    return "Фигура"

class Rule(abc.ABC):
    @abc.abstractproperty
    def name(self):
        pass

    @abc.abstractmethod
    def check(self, **kwargs):
        pass

class FigureHasLabelRule(Rule):
    @property
    def name(self):
        return "Отсутствие метки"

    def check(self, **kwargs):
        figures = kwargs.get('figures', [])
        errors = []
        for i, fig in enumerate(figures):
            if fig.get('kind') == 'hidden_appendix':
                continue
            if 'label' not in fig or not fig['label']:
                kind_name = get_figure_kind_name(fig)
                caption_text = self._get_caption(fig)
                errors.append(f"{kind_name} '{truncate(caption_text)}': отсутствует метка (label)")
        return errors

    def _get_caption(self, fig):
        caption = fig.get('caption')
        if not caption:
            return "<Без подписи>"
        body = caption.get('body')
        if not body:
             return "<Пустая подпись>"
        return extract_text(body).strip()

class LabelIsReferencedRule(Rule):
    @property
    def name(self):
        return "Неиспользуемая метка"

    def check(self, **kwargs):
        figures = kwargs.get('figures', [])
        refs = kwargs.get('refs', [])
        all_figure_labels = {fig['label'] for fig in figures 
                             if 'label' in fig and fig['label'] and fig.get('kind') != 'hidden_appendix'}
        all_referenced_targets = set(refs)
        
        errors = []
        for label in sorted(list(all_figure_labels)):
            if label != "<appendix>" and label not in all_referenced_targets:
                errors.append(f"Метка {Colors.CYAN}{label}{Colors.END}: на неё нет ни одной ссылки в тексте")
        return errors

class CaptionNoTrailingPunctuationRule(Rule):
    @property
    def name(self):
        return "Знак препинания в конце подписи"

    def check(self, **kwargs):
        figures = kwargs.get('figures', [])
        errors = []
        punctuation_marks = (".", "!", "?", ":", ";")
        for i, fig in enumerate(figures):
            if fig.get('kind') == 'hidden_appendix':
                continue
            caption = fig.get('caption')
            if not caption:
                continue
            body = caption.get('body')
            if not body:
                continue
            text = extract_text(body).strip()
            if text and text.endswith(punctuation_marks):
                kind_name = get_figure_kind_name(fig)
                errors.append(f"{kind_name} '{truncate(text)}': подпись заканчивается точкой или иным знаком препинания")
        return errors

class HeadingPunctuationRule(Rule):
    @property
    def name(self):
        return "Пунктуация в заголовках"

    def check(self, **kwargs):
        headings = kwargs.get('headings', [])
        errors = []
        punctuation_marks = (".", "!", "?", ":", ";")
        
        for i, h in enumerate(headings):
            level = h.get('level', 1)
            body = h.get('body')
            if not body:
                continue
            text = extract_text(body).strip()
            if not text:
                continue

            if level in (1, 2):
                if text.endswith(punctuation_marks):
                    errors.append(f"Заголовок {level}-го уровня '{truncate(text)}': обнаружен знак препинания в конце")
            elif level == 3:
                if not text.endswith("."):
                    errors.append(f"Заголовок 3-го уровня '{truncate(text)}': в конце обязательно должна быть точка")
        return errors

class ListPunctuationRule(Rule):
    @property
    def name(self):
        return "Пунктуация в списках"

    def check(self, **kwargs):
        lists = kwargs.get('lists', [])
        errors = []
        
        for list_idx, lst in enumerate(lists):
            children = lst.get('children', [])
            if not children:
                continue
            for item_idx, item in enumerate(children):
                body = item.get('body')
                if not body:
                    continue
                text = extract_text(body).strip()
                if not text:
                    continue
                
                context = f"Элемент '{truncate(text, 40)}'"
                # 1. Проверка на строчную букву
                if text[0].isupper():
                    errors.append(f"{context}: должен начинаться со строчной (маленькой) буквы")
                
                # 2. Проверка знаков в конце
                is_last = (item_idx == len(children) - 1)
                if is_last:
                    if not text.endswith("."):
                        errors.append(f"{context}: последний элемент списка обязан заканчиваться точкой")
                else:
                    if not text.endswith(";"):
                        errors.append(f"{context}: должен заканчиваться точкой с запятой ';'")
        return errors

class Linter:
    def __init__(self):
        self.rules = []

    def add_rule(self, rule):
        self.rules.append(rule)

    def lint(self, file_path):
        try:
            print(f"  {Colors.YELLOW}»{Colors.END} Сбор данных...")
            figures = self._query(file_path, "figure")
            refs = self._query(file_path, "ref", field="target")
            headings = self._query(file_path, "heading")
            lists = self._query(file_path, "list")
        except subprocess.CalledProcessError as e:
            return {"Ошибка": [f"Ошибка выполнения 'typst query': {e.stderr.strip()}"]}
        except Exception as e:
            return {"Ошибка": [f"Произошла непредвиденная ошибка: {e}"]}

        all_errors = {}
        context = {"figures": figures, "refs": refs, "headings": headings, "lists": lists}
        for rule in self.rules:
            errors = rule.check(**context)
            if errors:
                all_errors[rule.name] = errors
        return all_errors

    def _query(self, file_path, selector, field=None):
        cmd = ["typst", "query", file_path, selector, "--format", "json"]
        if field:
            cmd.extend(["--field", field])
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        if not result.stdout.strip():
            return []
        return json.loads(result.stdout)

def main():
    if len(sys.argv) < 2:
        print(f"{Colors.BOLD}Использование:{Colors.END} python linter/linter.py <файл_typst>")
        sys.exit(1)

    file_paths = sys.argv[1:]
    linter = Linter()
    linter.add_rule(FigureHasLabelRule())
    linter.add_rule(LabelIsReferencedRule())
    linter.add_rule(CaptionNoTrailingPunctuationRule())
    linter.add_rule(HeadingPunctuationRule())
    linter.add_rule(ListPunctuationRule())

    for path in file_paths:
        print(f"\n{Colors.BOLD}{Colors.BLUE}Анализ файла:{Colors.END} {Colors.BOLD}{path}{Colors.END}")
        results = linter.lint(path)
        
        if not results:
            print(f"  {Colors.GREEN}✔ Ошибок не обнаружено{Colors.END}")
        else:
            for rule_name, errors in results.items():
                print(f"\n  {Colors.YELLOW}{Colors.BOLD}[{rule_name}]{Colors.END}")
                for err in errors:
                    print(f"    {Colors.RED}●{Colors.END} {err}")
        print(f"{Colors.CYAN}{'-' * 60}{Colors.END}")

if __name__ == "__main__":
    main()
