# [Цитаты](/quotes/)

Количество цитат:

```bash
$ jq '.quotes | length' quotes-example.json 
```

Идентификаторы книг в которых сделаны цитаты:

```bash
jq --raw-output '' quotes-example.json | sort -u
```

Заголовки книг в которых сделаны цитаты:

```bash
jq --raw-output '.quotes[].book.title' public-quotes.json | sort -u
```

Создать HTML-файл книгами в которых сделаны цитаты:

```bash
jq --raw-output '.quotes[].book | "<a href=\"https://bookmate.com/books/" + .uuid + "\">" + .title + "</a> (" + (.quotes_count|tostring) + " всех цитат)<br/>"' public-quotes.json | sort -u > books.html
```

# [Книги](/books-private/)

Количество книг:

```bash
$ jq '.library_cards | length' public-books-example.json 
```
