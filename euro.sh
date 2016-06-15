#!/bin/bash

#$1 - today
echoAwayTeam() {
	local	awayTeam=$(echo "$1" | grep '"fixtures",0,"awayTeamName"' | tr -d '\011\"')
	awayTeam=${awayTeam#'[fixtures,0,awayTeamName]'}

	echo "$awayTeam"
}

today=$(curl -sH 'X-Auth-Token:5e7d2f5566404e9cb29e2f75bafc62d4' http://api.football-data.org/v1/soccerseasons/424/fixtures?timeFrame=n1)
today=$(echo "$today" | JSON.sh -l)

homeTeam=$(echo "$today" | grep '"fixtures",0,"homeTeamName"' | tr -d '\011\"')
homeTeam=${homeTeam#'[fixtures,0,homeTeamName]'}

awayTeam=$(echo "$today" | grep '"fixtures",0,"awayTeamName"' | tr -d '\011\"')
awayTeam=${awayTeam#'[fixtures,0,awayTeamName]'}

gameState=$(echo "$today" | grep '"fixtures",0,"status"' | tr -d '\011\"')
gameState=${gameState#'[fixtures,0,status]'}
#echo "$gameState"

if [ "$gameState" == 'IN_PLAY' ]; then
	homeTeamGoals=$(echo "$today" | grep '"fixtures",0,"result","goalsHomeTeam"' | tr -d '\011\"')
	homeTeamGoals=${homeTeamGoals#'[fixtures,0,result,goalsHomeTeam]'}

	awayTeamGoals=$(echo "$today" | grep '"fixtures",0,"result","goalsAwayTeam"' | tr -d '\011\"')
	awayTeamGoals=${awayTeamGoals#'[fixtures,0,result,goalsAwayTeam]'}

	echo "Current game: $homeTeam $homeTeamGoals - $awayTeamGoals $awayTeam"
else
	date=$(echo "$today" | grep '"fixtures",0,"date"' | tr -d '\011\"')
	date=${date#'[fixtures,0,date]'}
	date=$(date -d "$date" '+%d/%b/%Y %H:%M')

	echo "Next game: $homeTeam - $awayTeam  $date"
fi
