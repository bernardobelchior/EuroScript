#!/bin/bash

#$1 - today
echoAwayTeam() {
	local	awayTeam=$(echo "$1" | grep '"fixtures",0,"awayTeamName"' | tr -d '\011\"')
	awayTeam=${awayTeam#'[fixtures,0,awayTeamName]'}

	echo "$awayTeam"
}

#When the left mouse button is clicked
#launch the browser with a live score website
if [ "$BLOCK_BUTTON" == 1 ]; then
	xdg-open "http://www.meusresultados.com/"
fi

#Get the games in the next 3 days
today=$(curl -sH 'X-Auth-Token:5e7d2f5566404e9cb29e2f75bafc62d4' http://api.football-data.org/v1/soccerseasons/424/fixtures?timeFrame=n3)
today=$(echo "$today" | JSON.sh -l)

#Get the number of games in the array
count=$(echo "$today" | grep '"count"' | tr -d '\011')
count=${count#'["count"]'}

i="-1"
gameState='FINISHED'

#Cycle all the games until a unfinished game is found.
while [ $i -lt $count -a "$gameState" == 'FINISHED' ]; do 
	i=$[$i+1]
	gameState=$(echo "$today" | grep "\"fixtures\",$i,\"status\"" | tr -d '\011\"')
	gameState=${gameState#"[fixtures,$i,status]"}
done

#Get the teams' names
homeTeam=$(echo "$today" | grep "\"fixtures\",$i,\"homeTeamName\"" | tr -d '\011\"') 
homeTeam=${homeTeam#"[fixtures,$i,homeTeamName]"}

awayTeam=$(echo "$today" | grep "\"fixtures\",$i,\"awayTeamName\"" | tr -d '\011\"')
awayTeam=${awayTeam#"[fixtures,$i,awayTeamName]"}

#If the game is live, get their goals as well
#Otherwise just show the next game and its date
if [ "$gameState" == 'IN_PLAY' ]; then
	homeTeamGoals=$(echo "$today" | grep "\"fixtures\",$i,\"result\",\"goalsHomeTeam\"" | tr -d '\011\"')
	homeTeamGoals=${homeTeamGoals#"[fixtures,$i,result,goalsHomeTeam]"}

	awayTeamGoals=$(echo "$today" | grep "\"fixtures\",$i,\"result\",\"goalsAwayTeam\"" | tr -d '\011\"')
	awayTeamGoals=${awayTeamGoals#"[fixtures,$i,result,goalsAwayTeam]"}

	echo " Current game: $homeTeam $homeTeamGoals - $awayTeamGoals $awayTeam"
else
	date=$(echo "$today" | grep "\"fixtures\",$i,\"date\"" | tr -d '\011\"')
	date=${date#"[fixtures,$i,date]"}
	date=$(date -d "$date" '+%d/%b/%Y %H:%M')

	echo " Next game: $homeTeam - $awayTeam  $date"
fi
