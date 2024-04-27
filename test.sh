#! /bin/bash
echo "************OSS1 - Project1************"
echo -e "*\t  StudentID : 12211640\t      *"
echo -e "*\t  Name : EunSeop Shin\t      *"
echo -e  "***************************************\n"
while :
do
	echo -e "[MENU]\n\n"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in
players.csv"
	echo -e "\n2. Get the team data to enter a league position in teams.csv\n
3. Get the Top-3 Attendance matches in mateches.csv\n
4. Get the team's league position and team's top scorer in teams.csv & players.csv\n
5. Get the modified format of date_GMT in matches.csv\n
6. Get the data of the winning team by the largest difference on home stadium in
teams.csv & matches.csv\n
7. Exit"
	read -p "Enter your CHOICE (1~7):" menu
	case $menu in 
		1) read -p "Do you want to get the Heung-Min Son's data? (y/n) :" yn
			if [[ ${yn} -eq "y" ]]
			then 
				cat players.csv | awk -F ',' '$1~"Heung-Min Son" {printf("Team:%s, Apperance:%d, Goal:%d, Assist:%d\n\n",$4,$2,$7,$8)}'
			else
				continue
			fi;;
		2) read -p "What do you want to get the team data of league_position[1~20]:" num
			cat teams.csv |tail -n +2 | awk -F ',' -v n=$num 'NR==n {win_rate=$2/($2+$3+$4);  print NR,$1,win_rate}';;
		3) read -p "Do you want to know Top-3 attendance data and average attendance?(y/n):" yn
			if [[ ${yn} -eq "y" ]]
			then
				echo -e "***Top-3 Attendance Match***\n"
				cat matches.csv | tail -n +2 | sort -r -t ',' -k 2 -n  | head -3 |awk -F ',' '{printf("%s vs %s (%s)\n%d %s\n\n",$3,$4,$1,$2,$7)}'

			else
				continue
			fi;;

		4) read -p "Do you want to get each team's ranking and the hightest-scoring player? (y/n):" yn
			if [[ $yn -eq "y" ]]
			then
				target_team=$(cat teams.csv |tail -n +2 |sort -n -t, -k6 | awk -F, '{printf("%s,",$1)}')
				echo ""
				IFS=","
				i=0
				for team_ in $target_team
				do 	
				((i++))
				echo "$i $team_"
				cat players.csv | tail -n +2 | awk -F, -v team=$team_ '$4~team {print $1","$7}' | sort -r -n -t, -k2 | tr ',' ' '| head -1 ; echo "";
				done	
			else
				continue
			fi;;
		5) read -p "Do you want to modify the format of date? (y/n): " yn
		       if [ $yn = "y" ]
		       then
				cat matches.csv|sed -ne '2,11p' | sed 's/Aug/08/' | awk '{printf("%d/%d/%d %s\n",$3,$1,$2,$5)}' | cut -d, -f1
		       else
				continue
			fi;;
		6) cat teams.csv | tail -n +2 | awk -F, '{print NR")"$1}' | column
			read -p "Enter your team number: " num
			echo ""
			team_name=$(cat teams.csv | tail -n +2 | awk -F, -v team_num=$num 'NR==team_num {print $1}' | cut -d " " -f1)
			
			cat matches.csv | tail -n +2 | awk -F, -v team=$team_name '$3~team {print $3,$5,"vs",$6,$4":"$5-$6}'| sort -t: -n -r -k2

			;;
		7) echo "Bye!" 
			exit 1
	esac
done


