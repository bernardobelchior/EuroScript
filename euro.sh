#!/bin/bash

#$1 - today
echoAwayTeam() {
	local	awayTeam=$(echo "$1" | grep '"fixtures",0,"awayTeamName"' | tr -d '\011\"')
	awayTeam=${awayTeam#'[fixtures,0,awayTeamName]'}

	echo "$awayTeam"
}

#today=$(curl -sX GET http://api.football-data.org/v1/soccerseasons/424/fixtures?timeFrame=n1 | JSON.sh -l)

today='{"_links":{"self":{"href":"http://api.football-data.org/v1/soccerseasons/424/fixtures"},"soccerseason":{"href":"http://api.football-data.org/v1/soccerseasons/424"}},"count":3,"fixtures":[{"_links":{"self":{"href":"http://api.football-data.org/v1/fixtures/149859"},"soccerseason":{"href":"http://api.football-data.org/v1/soccerseasons/424"},"homeTeam":{"href":"http://api.football-data.org/v1/teams/808"},"awayTeam":{"href":"http://api.football-data.org/v1/teams/768"}},"date":"2016-06-15T13:00:00Z","status":"TIMED","matchday":2,"homeTeamName":"Russia","awayTeamName":"Slovakia","result":{"goalsHomeTeam":null,"goalsAwayTeam":null}},{"_links":{"self":{"href":"http://api.football-data.org/v1/fixtures/149854"},"soccerseason":{"href":"http://api.football-data.org/v1/soccerseasons/424"},"homeTeam":{"href":"http://api.football-data.org/v1/teams/811"},"awayTeam":{"href":"http://api.football-data.org/v1/teams/788"}},"date":"2016-06-15T16:00:00Z","status":"TIMED","matchday":2,"homeTeamName":"Romania","awayTeamName":"Switzerland","result":{"goalsHomeTeam":null,"goalsAwayTeam":null}},{"_links":{"self":{"href":"http://api.football-data.org/v1/fixtures/149884"},"soccerseason":{"href":"http://api.football-data.org/v1/soccerseasons/424"},"homeTeam":{"href":"http://api.football-data.org/v1/teams/773"},"awayTeam":{"href":"http://api.football-data.org/v1/teams/1065"}},"date":"2016-06-15T19:00:00Z","status":"TIMED","matchday":2,"homeTeamName":"France","awayTeamName":"Albania","result":{"goalsHomeTeam":null,"goalsAwayTeam":null}}]}'

today=$(echo "$today" | JSON.sh -l)

homeTeam=$(echo "$today" | grep '"fixtures",0,"homeTeamName"' | tr -d '\011\"')
homeTeam=${homeTeam#'[fixtures,0,homeTeamName]'}

awayTeam=$(echo "$today" | grep '"fixtures",0,"awayTeamName"' | tr -d '\011\"')
awayTeam=${awayTeam#'[fixtures,0,awayTeamName]'}

date=$(echo "$today" | grep '"fixtures",0,"date"' | tr -d '\011\"')
date=${date#'[fixtures,0,date]'}
date=$(date -d "$date" '+%d/%b/%Y %H:%M')

echo "Next game: $homeTeam - $awayTeam  $date"
