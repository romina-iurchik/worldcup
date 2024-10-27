#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
      #get team_id from winner
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      
      if [[ -z $TEAM_ID  ]]
      then
        INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        echo $WINNER
      fi
      #get team_id from opponent
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      if [[ -z $TEAM_ID  ]]
      then
        INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        echo $OPPONENT
      fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
      #get team_id from opponent
      OPPO_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #get team_id from winner
      WINN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")


      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINN_ID, $OPPO_ID, $WINNER_GOALS, $OPPONENT_GOALS)")


  fi
done