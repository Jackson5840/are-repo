from PIL import Image, ImageDraw
import imageio
import math
import time
import os
import redis
from . import io
import logging

def rotate(img,angle):
	img = img.rotate(angle)
def findnextindex(dict, parentindex):
	returner = []
	for key,value in dict.items():
		#print(value[2], "hi", parentindex)
		if(value[2]==parentindex):
			#print('hello i am here')
			returner.append(key)
	return returner
#t= time.time() #initial time

def gifgen(inputdirectoryPath,outputdirectoryPath,archive):
	r = redis.Redis(host='localhost', port=6379, db=0)
	filename = "mo file read yet"
	
	try:
		#inputdirectoryPath = "E:\\Krasnow\\gifgeneration\\input\\"
		#save location
		#pdfname = os.path.join(inputdirectoryPath, "front.png")
		#swc file
		#outputdirectoryPath = "E:\\Krasnow\\gifgeneration\\output"
		nFiles = len(os.listdir(inputdirectoryPath))
		fileix = 0
		r.set("{}_gif_status".format(archive),'success')
		r.set("{}_gif_progress".format(archive),fileix/nFiles*100)
		for filename in os.listdir(inputdirectoryPath):
			
			textname = os.path.join(inputdirectoryPath, filename)
			# logging.info('textname : {}'.format(textname))
			#print(filename)
			#DEFINITIONS OF COLORS
			white = (255, 255, 255)
			black = (0, 0, 0)
			blue = (0, 0, 255)
			red = (255, 0, 0)
			green = (0,128,0)
			purple = (255,0,255)
			pink = (255,192,203)
			gray = (128,128,128)
			#END OF COLOR DEFS
			#SIZE CONSTRAINT!!
			totalpixels = 62500 #MAKE THIS HIGHER FOR HIGHER RESOLUTION. WILL TAKE MORE TIME.
			#START:
			linecount = 0 #later used for growing, ensuring we grow within 1 full rotation
			#print("start")
			f = open(textname, "r")
			try: 
				lines = f.readlines()
			except UnicodeDecodeError as e:
				f.close()
				f = open(textname, "r", encoding='iso-8859-1')
				lines = f.readlines()
			dictionary = {} #KEY IS INTEGER INDEX OF LINE, VALUE IS [COORDINATES,radius,parent,color]
			for line in lines:
				line = line.replace('  ', ' ')
				if(line[0]==' '):
					line = line[1:]
				if(line[0]!='#' and line[0]!='\n'): #STRIP ALL THE COMMENTS, STRIP EVERYTHING THAT ISN'T COORDINATES
					##NOW WE READ THE LINES
					arr = line.split(' ')
					dictionary[int(arr[0])] = [(float(arr[2]),float(arr[3]),float(arr[4])),float(arr[5]),int(arr[6]),int(arr[1])] #make the dictionary
					linecount+=1

			##THE PURPOSE OF THE NEXT CODE BIT IS TO RE-ORDER THE NODES. THIS WAY, IT GROWS FROM THE ROOT RATHER THAN ONE BRANCH AT A TIME. ##################
			newdict = {}
			newdict[1]=dictionary[1]
			#print(newdict[1])
			order = findnextindex(dictionary,1)
			#logging.info(order)
			previouslen = 0
			lenrightnow = len(order)
			#logging.info('before while : {}'.format(lenrightnow))
			while(len(order)<linecount-1):
				for i in range(previouslen,lenrightnow):
					order.extend(findnextindex(dictionary,order[i]))
				previouslen = lenrightnow
				lenrightnow = len(order)
				#logging.info('previouslen : {}'.format(previouslen))
				#logging.info('now : {}'.format(lenrightnow))
			neword = [1]
			neword.extend(order)
			order = neword

			######################################################################
			#
			##THE NEXT CODE BIT IS TO DETERMINE THE MINIMUM AND MAXUMUM X, Y, AND Z VALUES SO THAT. WE CAN SCALE THE IMAGE TO THE FRAME, NO MATTER HOW BIG/SMALL THE NEURON IS.
			linesperdegree = math.ceil(linecount/360) #make sure we draw the whole neuron in 360 degrees.
			maxX = 0
			minX = 0
			maxY = 0
			minY = 0
			maxZ = 0
			minZ = 0
			for key,value in dictionary.items():
				if(value[0][0]>maxX):
					maxX = value[0][0]
				if(value[0][0]<minX):
					minX = value[0][0]
				if(value[0][1]>maxY):
					maxY = value[0][1]
				if(value[0][1]<minY):
					minY = value[0][1]
				if(value[0][2]>maxZ):
					maxZ = value[0][2]
				if(value[0][2]<minZ):
					minZ = value[0][2]
			#print(maxX)
			#print(minX)
			#print(maxY)
			#print(minY)
			#print(maxZ)
			#print(minZ)
			maxVal = max([maxX,-1*minX,maxY,-1*minY,maxZ,-1*minZ]) #the height and width of the square frame the gif will be in.
			maximumX = max(maxX,-1*minX,maxZ,-1*minZ)
			maximumY = max(maxY,-1*minY)
			ratiowh = 1.0*maximumX/maximumY
			## height/width=ratiowh
			## height*width=totalpixels
			## ratiowh*width = totalpixels/width
			## wdth^2 = totalpixels/ratiowh
			## wdith = sqrt(totalpixels/ratiowh	)
			## solve the above system of equations to get width and height.
			height = math.sqrt(totalpixels/ratiowh)*1.0
			width = totalpixels/height*1.0
			width = int(round(width))
			height = int(round(height))

			for i in range(360):
				pdfname = os.path.join(inputdirectoryPath , "front"+str(i)+".png") #naming the image, based on which degree we are on.
				image = Image.new("RGB", (width,height), white) #create the image
				draw = ImageDraw.Draw(image)
				
				#print(maxVal)

				hratio = (height-5)/2/maximumY #this will later help us scale the image.
				wratio = (width-5)/2/maximumX
				#print(ratio)
				tempcounter = 0
				maxline = i*linesperdegree*2
				for key in order:
					value = dictionary[key]
					if(tempcounter<=maxline):
						if(value[2]!=-1):
							x2 = (width/2)+value[0][0]*wratio #these next 4 lines just get the x,y of the starting and ending points (and of course scale them using the ratio we calculated earlier)
							y2 = (height/2)-value[0][1]*hratio
							x1 = (width/2)+dictionary[value[2]][0][0]*wratio
							y1 = (height/2)-dictionary[value[2]][0][1]*hratio
							if(dictionary[key][3]==1): #these if-statements are just to color the line correctly, the last number is the width of the line (5 pixels is just a visible width)
								draw.line((x1,y1,x2,y2),red,5)
							if(dictionary[key][3]==2):
								draw.line((x1,y1,x2,y2),gray,1)
							if(dictionary[key][3]==3):
								draw.line((x1,y1,x2,y2),green,1)
							if(dictionary[key][3]==4):
								draw.line((x1,y1,x2,y2),purple,1)
							if(dictionary[key][3]==6):
								draw.line((x1,y1,x2,y2),pink,1)
							if(dictionary[key][3]==7):
								draw.line((x1,y1,x2,y2),blue,1)
							tempcounter+=1
				image.save(pdfname) #saves the image
				#print(pdfname)
				for(key,value) in dictionary.items():
					x = value[0][0]
					y = value[0][1]
					z = value[0][2]
					#ROTATE AROUND Y - THIS IS WHAT WE WANT, THIS WAY OUR NEXT IMAGE WILL LOOK ROTATED COMPARED TO THIS ONE.
					newz = z*math.cos(0.0174533*2)-x*math.sin(0.0174533*2) #number is 1 degree in radians
					newx = z*math.sin(0.0174533*2)+x*math.cos(0.0174533*2)
					newy = y
					value[0]=(newx,newy,newz)
			f.close()
			##HERE WE MAKE A LIST OF THE JPG FILES TO LATER COMBINE INTO THE GIF.
			filenameslist = []
			#logging.info(filenameslist)
			images = []
			for i in range(360):
				file =  os.path.join(inputdirectoryPath , "front"+str(i)+".png")
				filenameslist.append(file)
			#AND HERE WE MAKE THE GIF USING THE LIST OF JPG FILES WE JUST MADE
			for flName in filenameslist:
				images.append(imageio.imread(flName))
			#SAVE THE GIF
			imageio.mimsave(os.path.join(outputdirectoryPath, str(filename.split(".")[0] + ".CNG.gif")), images)
			#t1 = time.time() #final time
			#print(t1-t) #PRINT TOTAL TIME TAKEN
			#print('done!')
			#done.
			#transfer gif
			io.transfergif(filename.split(".")[0])
			fileix += 1
			r.set("{}_gif_status".format(archive),'success')
			r.set("{}_gif_progress".format(archive),fileix/nFiles*100)
			

	except Exception as e:
		logging.exception('An error occurred during GIF generation of file %s: %s: %s' % (filename,e.__class__, e))
		r = redis.Redis(host='localhost', port=6379, db=0)
		r.set("{}_gif_status".format(archive),'error')
		raise e

	finally:
		for delFile in os.listdir(inputdirectoryPath):
			if delFile.endswith(".png"): 
				os.remove(os.path.join(inputdirectoryPath, delFile))



