import fileinput

# TODO: Justify text
# TODO: Better Naming variables and better dividing into functions
# TODO: Scrapy  exercise and database exercise

def justified_text(text_array,line_letters_count):
	# TODO:
	missing_space = 40 - line_letters_count;
	print(missing_space,len(text_array));
	if(missing_space == len(text_array)-1):
		text_result = " ".join(text_array);
	else:
		text_result = "";
		for word in text_array:

			maximum_space_btw = missing_space / len(text_array)
			print(int(round(maximum_space_btw)));
			if(maximum_space_btw > 1):
				text_result += word + (" "*int(round(maximum_space_btw)))
			else:
				text_result += word + (" ")
			missing_space -= maximum_space_btw
			print(text_result)
	return text_result;

def reached_40characters(is_justified,line_counts,word_length,new_line):
	if not is_justified:
		return line_counts + word_length + len(new_line) > 40
	else:
		return line_counts + word_length + len(new_line) > 40;

def formatLine40(line,is_justified):
	# This function will return

	line_words = line.split()
	line_counts = 0
	lines40_array = []
	new_line = []

	for word in line_words:
		word_length = len(word)
		
		if(reached_40characters(is_justified,line_counts,word_length,new_line)):
			if is_justified:
				line = justified_text(new_line,line_counts);
			else:
				line = " ".join(new_line);

			lines40_array.append(line);
			new_line = []
			line_counts = 0;

		line_counts += word_length
		new_line.append(word)
	
	line = " ".join(new_line);
	lines40_array.append(line);

	return lines40_array;

def read_file(file_name):
	
	file = open(file_name,"r");
	text = [];
	for line in file.readlines():
		text.append(line);
	return text;

def main():

	text_imported = read_file("text_example1.txt");
	is_justified = 1;
	for line in text_imported:
		lines_40 = formatLine40(line,is_justified);
		print("\n".join(lines_40));

	return 0;

main();