#! /bin/bash
# ./proj1_12211640_ShinEunSeop teams.csv players.csv matches.csv
if [ $# -ne 3 ]; then
	echo "usage: $0 file1 file2 file3"
	exit 2
fi

for file in $*
do
if [[ $file != *.csv ]]; then
	echo "NOT CSV FILE: $file"
	exit 2
fi
done

echo "************OSS1 - Project1************"
echo -e "*\t  StudentID : 12211640\t      *"
echo -e "*\t  Name : EunSeop Shin\t      *"
echo -e  "***************************************\n"

while :
do
	echo -e "\n[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv"
	echo -e "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in mateches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
	echo "7. Exit"
	read -p "Enter your CHOICE (1~7):" menu
	case $menu in 
		1) read -p "Do you want to get the Heung-Min Son's data? (y/n): " yn
			if [ $yn = "y" ]
			then 
				cat $2 | awk -F ',' '$1~"Heung-Min Son" {printf("Team:%s, Apperance:%d, Goal:%d, Assist:%d\n\n",$4,$6,$7,$8)}'
			elif [ $yn = "n" ]; then
				continue
			else
				echo -e "\nERROR:INVALID INPUT $yn"
			fi;;
		2) read -p "What do you want to get the team data of league_position[1~20]:" num

			if [[ $num =~ ^[0-9]+$ ]] && [ $num -le 20 ] && [ $num -ge 1 ]; then cat $1 |tail -n +2 | sort -t, -n -k6 | awk -F ',' -v n=$num 'NR==n {win_rate=$2/($2+$3+$4);  print NR,$1,win_rate}'
                        else
                                echo -e "\nINVALID TEAM NUMBER $num"
                                continue
                        fi;;
		3) read -p "Do you want to know Top-3 attendance data and average attendance?(y/n):" yn
			if [ $yn = "y" ]
			then
				echo -e "***Top-3 Attendance Match***\n"
				cat $3 | tail -n +2 | sort -r -t ',' -k 2 -n  | head -3 | awk -F ',' '{printf("%s vs %s (%s)\n%d %s\n\n",$3,$4,$1,$2,$7)}'
			elif [ $yn = "n" ]; then
                                continue
                        else
                                echo -e "\nERROR:INVALID INPUT $yn"
                        fi;;
		4) read -p "Do you want to get each team's ranking and the hightest-scoring player? (y/n):" yn
			if [ $yn = "y" ]
			then
				target_team=$(cat $1 | tail -n +2 | sort -n -t, -k6 | awk -F, '{printf("%s,",$1)}')
				echo ""
				IFS=","
				i=0
				for team_ in $target_team
				do 	
				((i++))
				echo "$i $team_"
				cat $2 | tail -n +2 | awk -F, -v team=$team_ '$4~team {print $1","$7}' | sort -r -n -t, -k2 | tr ',' ' '| head -1 ; echo "";
				done	
			elif [ $yn = "n" ]; then
                                continue
                        else
                                echo -e "\nERROR:INVALID INPUT $yn"
                        fi;;
		5) read -p "Do you want to modify the format of date? (y/n): " yn
		       if [ $yn = "y" ]
		       then
				 cat $3 | sed -ne '2,11p' | sed -e 's/Jan/01/' -e 's/Feb/02/' -e 's/Mar/03/' -e 's/Apr/04/' -e 's/May/05/' -e 's/Jun/06/' -e 's/Jul/07/' -e 's/Aug/08/' -e 's/Sep/09/' -e 's/Oct/10/' -e 's/Nov/11/' -e 's/Dev/12/' | awk '{printf("%d/%s/%d %s\n",$3,$1,$2,$5)}' | cut -d, -f1

			elif [ $yn = "n" ]; then
                                continue
                        else
                                echo -e "\nERROR:INVALID INPUT $yn"
                        fi;;
		6) cat $1 | tail -n +2 | awk -F, '{print NR")"$1}' | column
			read -p "Enter your team number: " num
			if [[ $num =~ ^[0-9]+$ ]] && [ $num -le 20 ] && [ $num -ge 1 ]; then team_name=$(cat $1 | tail -n +2 | awk -F, -v team_num=$num 'NR==team_num {print $1}' | cut -d " " -f1)
				echo ""
				cat $3 | tail -n +2 | awk -F, -v team=$team_name '$3~team {printf("%s/%s %d vs %d %s/%d\n",$1,$3,$5,$6,$4,$5-$6)}'| sort -t/ -n -r -k3 | awk -F/ 'BEGIN {max=-10000} $3 >= max {printf("%s\n%s\n\n",$1,$2);max=$3}'
			else
				echo -e "\nINVALID TEAM NUMBER $num"
				continue
			fi;;
		7) echo -e "Bye!\n" 
			exit 1;;
		*) echo -e "\nERROR:INVALID NUMBER $menu"
	esac
done


