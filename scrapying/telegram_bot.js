const TelegramBot = require('node-telegram-bot-api');
const Rebbit = require('./scrapying');
const token = '438921418:AAGFFZPDv-HkJgcO-tnLiXR7XwItvgE48RQ';
const bot = new TelegramBot(token, {polling: true});


sendMessage = function(chatId,message,...extraField){
  bot.sendMessage(chatId,message,extraField[0]);
}

sendFailedMessage = function(chatId,error){
  let errorMessage = "There was an error."
  sendMessage(chatId,errorMessage)
}

sendSuccesfulMessage = function(chatId,topThreads){
    topThreads.forEach(function(subReddit){
      subRedditName = Object.keys(subReddit)[0];
      if(subReddit[subRedditName] == 0){
        noTopThread = "Subthread: "+ subRedditName +". Does not have thread with score greather than 5000"
        bot.sendMessage(chatId,noTopThread);
      }
      else{
        subReddit[subRedditName].forEach(function(thread){
          textMessage = "<b>"+thread["threadTitle"]+"</b> \n <em>SubReddit:"+ thread["subreddit"]+ " Votes: "+ thread["upvotes"]+"</em>\n "+thread["commentaryLink"]+" \n"
          bot.sendMessage(chatId,textMessage,{parse_mode : "HTML"});
        })
      }
    });
}

bot.onText(/\/NadaPraFazer (.+)/, (msg, match) => {
  

  const chatId = msg.chat.id;
  const resp = match[1]; 
  const subReddits = match[1].split(";");
  
  Rebbit(subReddits,function(error,subReddits){
      if(error){
        sendFailedMessage(chatId,error);
      }
      else{
        sendSuccesfulMessage(chatId,subReddits);
      }
  });
});



// Listen for any kind of message. There are different kinds of
// messages.
bot.on('message', (msg) => {
  const chatId = msg.chat.id;

  // send a message to the chat acknowledging receipt of their message
  bot.sendMessage(chatId, 'Received your message');
});