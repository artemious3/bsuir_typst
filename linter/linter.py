import json
import subprocess
import sys
import abc

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
        return "ОтсутствиеМетки"

    def check(self, **kwargs):
        figures = kwargs.get('figures', [])
        errors = []
        for i, fig in enumerate(figures):
            if fig.get('kind') == 'hidden_appendix':
                continue
            if 'label' not in fig or not fig['label']:
                caption_text = self._get_caption(fig)
                errors.append(f"У фигуры №{i+1} отсутствует label, следовательно, и ссылка. Подпись: '{caption_text}'")
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
        return "НеиспользуемаяМетка"

    def check(self, **kwargs):
        figures = kwargs.get('figures', [])
        refs = kwargs.get('refs', [])
        all_figure_labels = {fig['label'] for fig in figures 
                             if 'label' in fig and fig['label'] and fig.get('kind') != 'hidden_appendix'}
        all_referenced_targets = set(refs)
        
        errors = []
        for label in sorted(list(all_figure_labels)):
            if label != "<appendix>" and label not in all_referenced_targets:
                errors.append(f"На метку {label} нет ссылок в тексте")
        return errors

class CaptionNoTrailingPunctuationRule(Rule):
    @property
    def name(self):
        return "ЗнакПрепинанияВКонцеПодписи"

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
                errors.append(f"Подпись фигуры №{i+1} заканчивается значком препинания: '{text}'")
        return errors

class HeadingPunctuationRule(Rule):
    @property
    def name(self):
        return "ПунктуацияЗаголовков"

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
                    errors.append(f"Заголовок {level}-го уровня заканчивается значком препинания: '{text}'")
            elif level == 3:
                if not text.endswith("."):
                    errors.append(f"Заголовок 3-го уровня должен заканчиваться точкой: '{text}'")
        
        return errors

class ListPunctuationRule(Rule):
    @property
    def name(self):
        return "ПунктуацияСписков"

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
                
                # 1. Проверка на строчную букву
                if text[0].isupper():
                    errors.append(f"Элемент списка №{item_idx+1} в списке №{list_idx+1} должен начинаться со строчной буквы: '{text}'")
                
                # 2. Проверка знаков в конце
                is_last = (item_idx == len(children) - 1)
                if is_last:
                    if not text.endswith("."):
                        errors.append(f"Последний элемент списка №{list_idx+1} должен заканчиваться точкой: '{text}'")
                else:
                    if not text.endswith(";"):
                        errors.append(f"Элемент списка №{item_idx+1} в списке №{list_idx+1} должен заканчиваться точкой с запятой: '{text}'")
                        
        return errors

class Linter:
    def __init__(self):
        self.rules = []

    def add_rule(self, rule):
        self.rules.append(rule)

    def lint(self, file_path):
        try:
            print(f"  - Сбор данных о фигурах...")
            figures = self._query(file_path, "figure")
            print(f"  - Сбор данных о ссылках...")
            refs = self._query(file_path, "ref", field="target")
            print(f"  - Сбор данных о заголовках...")
            headings = self._query(file_path, "heading")
            print(f"  - Сбор данных о списках...")
            lists = self._query(file_path, "list")
        except subprocess.CalledProcessError as e:
            return {"Ошибка": [f"Ошибка выполнения 'typst query': {e.stderr.strip()}"]}
        except Exception as e:
            return {"Ошибка": [f"Произошла непредвиденная ошибка: {e}"]}

        print(f"  - Проверка правил...")
        all_errors = {}
        context = {
            "figures": figures,
            "refs": refs,
            "headings": headings,
            "lists": lists
        }
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
        print("Использование: python linter/linter.py <файл_typst>")
        sys.exit(1)

    file_paths = sys.argv[1:]
    linter = Linter()
    linter.add_rule(FigureHasLabelRule())
    linter.add_rule(LabelIsReferencedRule())
    linter.add_rule(CaptionNoTrailingPunctuationRule())
    linter.add_rule(HeadingPunctuationRule())
    linter.add_rule(ListPunctuationRule())

    for path in file_paths:
        results = linter.lint(path)
        
        if not results:
            print(f"Анализ {path}: ОШИБОК НЕ ОБНАРУЖЕНО")
        else:
            print(f"Анализ {path}: Найдены проблемы!")
            for rule_name, errors in results.items():
                print(f"\n[{rule_name}]")
                for err in errors:
                    print(f"  - {err}")
            print("-" * 40)

if __name__ == "__main__":
    main()
