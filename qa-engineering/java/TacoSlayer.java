var slaying = true;
var youHit = Math.floor(Math.random()*2);
var damageThisRound = Math.floor(Math.random()*5 + 1);
var totalDamage = 0;

while(slaying){
    if(youHit){
        console.log("You beat the hot crap out of that taco!");
        totalDamage += damageThisRound;
        if(totalDamage >= 4){
            console.log("You just slit the taco's neck! He dead now!");
            slaying=false;
        } else {
            youHit = Math.floor(Math.random()*2);
        }
    } else {
        console.log("The taco just mopped the floor with your blood!");
    }slaying=false;
}