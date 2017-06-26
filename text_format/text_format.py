import fileinput

# TODO: Justify text
# TODO: Better Naming variables and better dividing into functions

width  = 40;

def justified_text(line_words,line_size):
	
	number_words_line = len(line_words) - 1 
	missing_space = 40 - line_size;

	if(missing_space == number_words_line):
		text_result = " ".join(line_words);
	else:
		text_result = "";
		index = 0;
		for word in line_words:
			if(number_words_line > index):
				rest = missing_space % (number_words_line - index);
				maximum_space_btw = int(round(missing_space / (number_words_line - index)));
				space_btw_text = maximum_space_btw;

				if(rest >= 1):
					space_btw_text += 1;
					missing_space -= 1;
		
				text_result += word + (" "*space_btw_text);
				missing_space -= maximum_space_btw;
				index += 1;
			else:
				text_result += word
	
	return text_result;

def format_line(is_justified,line_words,line_size):

	if is_justified == 1:
		line = justified_text(line_words,line_size);
	else:
		line = " ".join(line_words);
	return line;

def limit_line_by_width(line,is_justified):

	paragraph_words = line.split()
	line_size = 0
	paragraph_lines = []
	line_words = []

	for word in paragraph_words:
		word_size = len(word)
		
		if(line_size + word_size + len(line_words) > width):
			line = format_line(is_justified,line_words,line_size);
			paragraph_lines.append(line);
			line_words = []
			line_size = 0;

		line_size += word_size
		line_words.append(word)
	line = format_line(is_justified,line_words,line_size)
	paragraph_lines.append(line);

	return paragraph_lines;

def read_file(file_name):
	
	file = open(file_name,"r");
	text = [];
	for line in file.readlines():
		text.append(line);
	return text;

def main():
	# file_name = input("Insert name of the file containing the text to be formated:"); 
	file_name = "text_example1.txt";
	print(file_name);
	text_imported = read_file(file_name);
	is_justified = int(input("Do you want to be justified? (1-Yes, 0-No) "));
	print(is_justified);
	for line in text_imported:
		lines_40 = limit_line_by_width(line,is_justified);
		print("\n".join(lines_40));

	return 0;

if __name__ =='__main__':
	main();