#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from PIL import Image, ImageDraw
import imageio
import math
import os
import redis
import logging

# Fixed input and output directories
INPUT_DIR = "/home/ingestion/are/single_gif/CNG"
OUTPUT_DIR = "/home/ingestion/are/single_gif/output"

def findnextindex(dictionary, parentindex):
    """Find all children of a given parent index"""
    return [key for key, value in dictionary.items() if value[2] == parentindex]

def gifgen():
    r = redis.Redis(host="localhost", port=6379, db=0)
    filename = "no file read yet"

    try:
        nFiles = len(os.listdir(INPUT_DIR))
        fileix = 0
        r.set("gif_status", "success")
        r.set("gif_progress", fileix / nFiles * 100)

        for filename in os.listdir(INPUT_DIR):
            textname = os.path.join(INPUT_DIR, filename)

            # Color definitions
            white = (255, 255, 255)
            red = (255, 0, 0)
            gray = (128, 128, 128)
            green = (0, 128, 0)
            purple = (255, 0, 255)
            pink = (255, 192, 203)
            blue = (0, 0, 255)

            totalpixels = 62500  # Controls resolution (higher = better but slower)
            linecount = 0

            # Read SWC file
            try:
                f = open(textname, "r")
                lines = f.readlines()
            except UnicodeDecodeError:
                f = open(textname, "r", encoding="iso-8859-1")
                lines = f.readlines()

            dictionary = {}
            for line in lines:
                line = line.strip()
                if line and not line.startswith("#"):
                    arr = line.split()
                    dictionary[int(arr[0])] = [
                        (float(arr[2]), float(arr[3]), float(arr[4])),
                        float(arr[5]),
                        int(arr[6]),
                        int(arr[1]),
                    ]
                    linecount += 1
            f.close()

            # Reorder nodes so growth starts at the root
            order = findnextindex(dictionary, 1)
            previouslen = 0
            lenrightnow = len(order)
            while len(order) < linecount - 1:
                for i in range(previouslen, lenrightnow):
                    order.extend(findnextindex(dictionary, order[i]))
                previouslen = lenrightnow
                lenrightnow = len(order)
            order = [1] + order

            # Calculate scaling factors
            maxX = maxY = maxZ = float("-inf")
            minX = minY = minZ = float("inf")
            for value in dictionary.values():
                x, y, z = value[0]
                maxX, minX = max(maxX, x), min(minX, x)
                maxY, minY = max(maxY, y), min(minY, y)
                maxZ, minZ = max(maxZ, z), min(minZ, z)

            maximumX = max(maxX, -minX, maxZ, -minZ)
            maximumY = max(maxY, -minY)
            ratiowh = maximumX / maximumY if maximumY != 0 else 1
            height = int(round(math.sqrt(totalpixels / ratiowh)))
            width = int(round(totalpixels / height))

            linesperdegree = math.ceil(linecount / 360)

            # Generate 360 frames
            for i in range(360):
                frame_path = os.path.join(INPUT_DIR, f"front{i}.png")
                image = Image.new("RGB", (width, height), white)
                draw = ImageDraw.Draw(image)

                hratio = (height - 5) / 2 / maximumY if maximumY != 0 else 1
                wratio = (width - 5) / 2 / maximumX if maximumX != 0 else 1

                tempcounter = 0
                maxline = i * linesperdegree * 2
                for key in order:
                    value = dictionary[key]
                    if tempcounter <= maxline and value[2] != -1:
                        x2 = (width / 2) + value[0][0] * wratio
                        y2 = (height / 2) - value[0][1] * hratio
                        x1 = (width / 2) + dictionary[value[2]][0][0] * wratio
                        y1 = (height / 2) - dictionary[value[2]][0][1] * hratio

                        color = {
                            1: red,
                            2: gray,
                            3: green,
                            4: purple,
                            6: pink,
                            7: blue,
                        }.get(dictionary[key][3], gray)

                        draw.line((x1, y1, x2, y2), color, 2)
                        tempcounter += 1

                image.save(frame_path)

                # Rotate all nodes (around Y axis by 2 degrees)
                for val in dictionary.values():
                    x, y, z = val[0]
                    angle = math.radians(2)
                    newz = z * math.cos(angle) - x * math.sin(angle)
                    newx = z * math.sin(angle) + x * math.cos(angle)
                    val[0] = (newx, y, newz)

            # Build GIF
            images = [imageio.imread(os.path.join(INPUT_DIR, f"front{i}.png")) for i in range(360)]
            out_gif = os.path.join(OUTPUT_DIR, f"{os.path.splitext(filename)[0]}.CNG.gif")
            imageio.mimsave(out_gif, images)

            fileix += 1
            r.set("gif_status", "success")
            r.set("gif_progress", fileix / nFiles * 100)

    except Exception as e:
        logging.exception("Error during GIF generation: %s", e)
        r.set("gif_status", "error")
        raise e

    finally:
        # Remove temporary PNG files
        for delFile in os.listdir(INPUT_DIR):
            if delFile.endswith(".png"):
                os.remove(os.path.join(INPUT_DIR, delFile))


if __name__ == "__main__":
    print("Starting GIF generation...")
    gifgen()
    print("Done! GIFs saved to:", OUTPUT_DIR)

