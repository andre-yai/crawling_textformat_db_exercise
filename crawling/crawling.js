
const request = require('request');
const cheerio = require('cheerio');
const async = require('async');

let RedditURL = 'https://www.reddit.com/r/'
let listofSubreddit = process.argv.slice(2);

let parseRedditPage = function(body){

	let $ = cheerio.load(body);
	let result = [];

	$('div.thing').each(function(){

		let subreddit = $(this).attr('data-subreddit');
		let thread_score = $(this).attr('data-score');
		if(thread_score >=  5000){
			
		//Titulo da thread e link da thread			
		let entry = $(this).find('div.entry')
		let titleSection = $(entry).find('p.title').find('a.title');
		let threadTitle = $(titleSection).text();
		let threadLink = $(titleSection).attr('data-href-url');

		//link para comentarios da thread
		let commentarySection = $(entry).find('ul.flat-list').find('li.first').find('a');
		let commentaryLink = $(commentarySection).attr('href');

		let redditThreadInfo = {upvotes: thread_score, subreddit: subreddit, threadTitle: threadTitle, threadLink:threadLink, commentaryLink:commentaryLink};

		result.push(redditThreadInfo);
		}
	});
	return result;
}

getSubredditPage = function (subReddit,callback){ 

	let webPage = RedditURL + subReddit;

	request(webPage,function(err,res,body) {

		let topThreads = [];

		if(err){
			return callback(err,null);
		}
			
		topThreads = parseRedditPage(body);
		return callback(null,topThreads);
	});

};
let current = Promise.resolve();

getTopThreadsFromSubReddits = function(listofSubreddit,callback){
	async.mapSeries(listofSubreddit, function(subReddit,callback){
		getSubredditPage(subReddit, function(err,res){
			if(err){
				return callback(err);
			}
			let obj = {}
			obj[subReddit] = res;
			return callback(null,obj);
		})
	},function(err,results){
		console.log(results);
		callback(err,results)
	});
}

function printTopThreads(topThreads){
		topThreads.forEach(function(subReddit){
		key = Object.keys(subReddit)[0];
		console.log("SubReddit:",key);
		if(subReddit[key] == 0){
			console.log("Does not have thread with score greather than 5000");
		}
		else{
			subReddit[key].forEach(function(thread){
				console.log(thread);
			})
		}
	
	})
}

getTopThreadsFromSubReddits(listofSubreddit,function(error,topThreads){

	if(error){
		console.log("Error:");
	}
	else{
		printTopThreads(topThreads);
	}
})

module.exports =  {getSubReddits: getTopThreadsFromSubReddits, parsePage: parseRedditPage};

