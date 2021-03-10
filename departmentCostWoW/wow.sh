#!/bin/bash
d=`date +%w` # Day of the week
date1=`date -v -"$[$d+14]"d +%Y-%m-%d` # Sunday 2 weeks ago
date2=`date -v -"$[$d+8]"d +%Y-%m-%d` # Saturday 2 weeks ago
date3=`date -v -"$[$d+7]"d +%Y-%m-%d` # Last Sunday
date4=`date -v -"$[$d+1]"d +%Y-%m-%d` # Last Saturday

# If no parameter. Get the total amount of each week and change of each department in the 2 weeks 
if [[ -z "$1" ]]; then
	filetotal="wow-total.`date +%Y-%m-%d`" # total amount of each week
	filedepart="wow-depart.`date +%Y-%m-%d`" # change of each department in the 2 weeks

	cp wow-total.tpl $filetotal
	cp wow-depart.tpl $filedepart

	perl -pi -e "s/date1/$date1/g" $filetotal 
	perl -pi -e "s/date2/$date2/g" $filetotal 
	perl -pi -e "s/date3/$date3/g" $filetotal 
	perl -pi -e "s/date4/$date4/g" $filetotal 

	perl -pi -e "s/date1/$date1/g" $filedepart
	perl -pi -e "s/date2/$date2/g" $filedepart
	perl -pi -e "s/date3/$date3/g" $filedepart
	perl -pi -e "s/date4/$date4/g" $filedepart

	echo
	echo "==Company Total=="
	echo
	cat $filetotal
	echo

	echo "==Department Total=="
	echo
	cat $filedepart
	echo

# Analyse the change of each service of each department in the 2 weeks
else

	filedepartservice="wow-departservice.`date +%Y-%m-%d`" 
	cp wow-departservice.tpl $filedepartservice
	perl -pi -e "s/date1/$date1/g" $filedepartservice
	perl -pi -e "s/date2/$date2/g" $filedepartservice
	perl -pi -e "s/date3/$date3/g" $filedepartservice
	perl -pi -e "s/date4/$date4/g" $filedepartservice

	echo "== Department Service =="
	echo

	echo 'select * from (('

	arrDept=($1)
	len=${#arrDept[@]}

	for (( i=0; i<$len; i++ )); do 
		IFS=':' read -ra arrdata <<< "${arrDept[$i]}"
		depname=${arrdata[0]}
		value=${arrdata[1]}

		echo "-- "$depname" --"

		tempfile=$filedepartservice-$depname
		cp $filedepartservice $tempfile
		perl -pi -e "s/department/$depname/g" $tempfile
		perl -pi -e "s/value/$value/g" $tempfile

		cat $tempfile
		if [ $i -lt  $((len-1)) ]; then
			echo ')union('
		fi
	done

	echo ')) where diff!=0 order by cast(depdiff as double) desc,dptmt,diff desc'
fi
