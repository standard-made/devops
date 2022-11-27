var troll = prompt("You're walking through the forest, minding your own business, and you run into a troll! Do you FIGHT him, PAY him, or RUN?").toUpperCase();

switch(troll) {
  case 'FIGHT':
    var strong = prompt("How courageous! Are you strong (YES or NO)?").toUpperCase();
    var smart = prompt("Are you smart?").toUpperCase();
    if(strong === 'YES' || smart === 'YES') {
      console.log("You only need one of the two! You beat the troll--nice work!");
    } else {
      console.log("You're not strong OR smart? Well, if you were smarter, you probably wouldn't have tried to fight a troll. You lose!");
    }
    break;
  case 'PAY':
    var money = prompt("All right, we'll pay the troll. Do you have any money (YES or NO)?").toUpperCase();
    var dollars = prompt("Is your money in Troll Dollars?").toUpperCase();
    if(money === 'YES' && dollars === 'YES') {
      console.log("Great! You pay the troll and continue on your merry way.");
    } else {
      console.log("Dang! This troll only takes Troll Dollars. You get whomped!");
    }
    break;
  case 'RUN':
    var fast = prompt("Let's book it! Are you fast (YES or NO)?").toUpperCase();
    var headStart = prompt("Did you get a head start?").toUpperCase();
    if(fast === 'YES' || headStart === 'YES') {
      console.log("You got away--barely! You live to stroll through the forest another day.");
    } else {
      console.log("You're not fast and you didn't get a head start? You never had a chance! The troll eats you.");
    }
    break;
  default:
    console.log("I didn't understand your choice. Hit Run and try again, this time picking FIGHT, PAY, or RUN!");
}




// EpicSECAdventure

var user = prompt("What is your favorite college football team in the SEC?").toUpperCase();

switch(user){
    case'AUBURN':
      var greatness = prompt("Did you graduate from there? (YES or NO)").toUpperCase();
      if (greatness === 'YES' || 'NO'){
        console.log("Doesn't matter; we're all cool!");
      } else {
        ;
      }
        break;
    case'UGA':
      var illness = prompt("Are you insane? (YES or NO)").toUpperCase();
      if (illness === 'YES'){
        console.log("That figures!");
      } else if (illness){
        console.log("Don't lie!");
      }
        break;
    case'ALABAMA':
      var dumbOne = prompt("Can you read this? (YES or NO)").toUpperCase();
      var dumbTwo = prompt("Are you sure? (YES or NO)").toUpperCase();
      if (dumbOne === 'YES' && dumbTwo === 'YES'){
        console.log("Nobody believes you!");
      } else {
        console.log("At least you're honest.");
      }
        break;
    default: 
        console.log("If it's not in the SEC, we don't care!");
}