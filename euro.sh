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

date=$(echo "$today" | grep '"fixtures",0,"date"' | tr -d '\011\"')
date=${date#'[fixtures,0,date]'}
date=$(date -d "$date" '+%d/%b/%Y %H:%M')

echo "Next game: $homeTeam - $awayTeam  $date"
