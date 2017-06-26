# crawling_textformat_sql_exercise
Crawling,text format and sql exercise
The answer for the database exercise and explanation it is in this file. See below.

#Crawling
I did it in NodeJs. 

I used cherrio  to crawl the reddit website and request to get the webpage. 

To call to crawl and get the top threads: 
node crawling cat askReddit
You should use space between the subReddits.

## Telegram Part 

And for telegram bot I used the telegram bot the node-telegram-bot-api bot. To use it you must first create a bot on telegram and get the access token provided and insert into the code.

To run:

node telegram_bot.js or node start

To call the task you should type in the conversation:

\NadaPraFazer cats;askReddit

Attention: you should use ';' as the example above.


# Text Format
In this folder I did an exercise where I format a text to have more or less 40 characters per line. For that I used Python.

To run you should type: python text_format.py

- Provide the file you want to format. For example: text_test1.txt

- And the type of format that you want to use (0 - for left or 1  - for justified). 


# Database Exercise
In the database exercise in order to improve performace we can use b-tree index. Index helps to better sctruturize the data and it helps to optmize queries.

To create index: 
Example: CREATE INDEX idx_entidade_cpf on db_entidade (cpf);


That even in a small test where we have like 10 elements in db_entidade we can get an better execution time.

We can also use cover and multiple index. 

But using a lot of index can reduce the performace of Insert,Update,Delete entry of a database.

If a table is changed quite a lot during a certain time it is recommended to Reindex the table. Reindex is a safe operation and can run even when you index running.

You can Reindex in a index or in a entire table.
 




