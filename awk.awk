$0 ~ /MODEL/ {
  printf $0" ";
  # ASSUMPTION: 3 iterations
  # TODO get rid of the magic constant 3 
	arr[0]=0
	arr[1]=0
	arr[2]=0
  # get numbers
	for(i=0; i<3; i++) 
	{
		getline;
		cmd="cat logs/"$0".err | egrep micro|awk '{ print $(NF-1) }'"
		#cmd="MOI"
		cmd | getline newVar
		close(cmd)
		#print newVar 
    arr[i] = newVar
	}
  # get average
	sum=0
	for(i=0;i<3;i++) 
	{
		#print "T:"arr[i]
		sum=sum+arr[i]
	}
  #print sum
  avg=sum/3
  
	# get stdev
	squareSumOfDev=0
	for(i=0;i<3;i++)
	{
		squareSumOfDev += (arr[i] - avg) ^ 2 
		#* (arr[i] - avg)   
	} 
	stdev = sqrt(squareSumOfDev/3)

	print "Avg: "avg" StDev: "stdev
}

