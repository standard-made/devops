/*jshint multistr:true */

var text = "This is a 8Kit string that contains some text and the name 8Kit";
var myName = "8Kit";
var hits = [];

for (var i = 0; i < text.length; i++){
    if (text[i]==="8"){
    for (var j=i; j < i + myName.length; j++){
    hits.push(text[j]);
    }
    }
}   if (hits.length===0){
    console.log("Your name wasn't found!");
} else {
    console.log(hits);    
}