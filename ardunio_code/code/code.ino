#include <SPI.h>
#include <SD.h>

#include "FastLED.h"
#define DATA_PIN 5
#define LMODEL WS2811
#define LRGB RGB
const int WIDTH = 28;
const int HEIGHT = 29;

//---------CONSTANTS VALUES----------//
const int PIXELs = 3;
const int ONE_PIC_SIZE = HEIGHT * WIDTH * 3;
const int NUM_LEDS = HEIGHT * WIDTH;
const int NO_OF_PARTS = 1; //
const int MAX_BYTES = ONE_PIC_SIZE / NO_OF_PARTS;
const int PAYLOAD = 60;
int displayCount = 10;

File myFile;
const char *filename = "data.txt";
CRGB leds[NUM_LEDS];

//////////////////////////////////////////////
// FIle Operations
/////////////////////////////////////////////
bool isFileOpen = false;
void openFile()
{
    if (!isFileOpen)
    {
        myFile = SD.open(filename);
        if (myFile)
        {
            // File opened successfully
            isFileOpen = true;
        }
        else
        {
            // Error opening file
            isFileOpen = false;
        }
    }
}

void closeFile()
{
    if (isFileOpen)
    {
        myFile.close();
        isFileOpen = false;
    }
}

void deleteFile(const char *fileToDelete)
{
    closeFile();
    if (SD.exists(fileToDelete))
    {
        SD.remove(fileToDelete);
    }
}

void appendData(const byte *data, int size)
{
    closeFile();
    File myFile1 = SD.open(filename, FILE_WRITE);
    if (myFile1)
    {
        myFile1.write(data, size);
        myFile1.close();
    }
}

//---------PIC ARRAY ----------//
byte receivedData[PAYLOAD];
byte PICS[MAX_BYTES];
int TOTAL_IMAGES = 0;
int TOTAL_PARTS = 0;
int LAST_RECIVED_BYTES = 0;

//---------SETUP---------------//
void setup()
{
    Serial.begin(9600);
    while (!Serial)
    {
        ; // wait for serial port to connect. Needed for native USB port only
    }

    FastLED.addLeds<LMODEL, DATA_PIN, LRGB>(leds, NUM_LEDS);
    FastLED.setBrightness(5);
    FastLED.clear();

    // Initialize the PICS array with all byte values set to 255
    memset(PICS, 255, sizeof(PICS));
    initializeSDCard();
    Serial.println("SD CARD INITIALIZED");
}
//---------LOOP---------------//
String command = "";
int imageLength = 0;
void loop()
{
    readSerialPayload();
    if (command != "")
    {
        performAction();
        command = "";
        Serial.flush();
    }
    else
    {
        if (displayCount-- < 0)
        {
            //  Serial.println("Display Image");
            displayPic();
            displayCount = 10;
        }
        else
        {
            delay(100);
        }
    }
}

void performAction()
{
    if (command == "Display Image")
    {
        command = "";
        Serial.println("Display Image");
        displayPic();
    }
    else if (command == "ready")
    {
        command = "";
        reply();
    }
    else if (command == "A")
    {
        command = "";
        delay(10);
        Serial.println("ALL SET");
    }
    else
    {
        command = "";
        Serial.println("Not Recognizied: ");
    }
}

void reply()
{
    delay(1000);
    String messa = "yes";
    Serial.println(messa);
    Serial.flush();
    verifyImageLength();
}

void verifyImageLength()
{
    delay(1000);
    command = "";
    readTill(30);
    if (command != "")
    {
        imageLength = command[0];
        if (imageLength > 0 && imageLength < 20)
        {
            Serial.println(imageLength);
            Serial.flush();
            delay(1000);
            getImages(imageLength);
        }
    }
    command = "";
}

// ----- Functions for reading Data and Waiting for them
void customDelay(int miliSeconds, int repeat, int aboveLength = 1)
{
    while (Serial.available() < aboveLength && repeat > 0)
    {
        repeat--;
        delay(miliSeconds);
    };
}
void readTill(int repeat)
{
    while (repeat > 0 && command == "")
    {
        delay(100);
        repeat--;
        readSerialPayload();
    }
}
void readSerialPayload()
{
    static String receivedString = ""; // Declare the receivedString variable as static
    while (Serial.available())
    {
        char receivedChar = Serial.read();
        if (receivedChar != '\n')
        {
            receivedString += receivedChar;
        }
        else
        {
            command = receivedString;
            receivedString = "";
        }
    }
}

//--------------Code To recive image --------------- //

void getImages(int totalImages)
{
    int totalChunks = 0;
    int totalBytes = 0;
    byte *ptr = &PICS[0]; // pointer for array
    int len = 0;
    int maxRecive = MAX_BYTES;
    TOTAL_PARTS = 0;
    delay(10);
    deleteFile(filename);
    while (true)
    {
        customDelay(500, 5); // 500*5 miliseconds max delay
        // READ DATA
        len = Serial.available();
        Serial.readBytes(receivedData, len);
        if (len < 3)
        {
            break; // data reciving end
        }
        else
        {

            for (int i = 0; i < len; i += 3)
            {
                *ptr = receivedData[i];
                ptr++;
                *ptr = receivedData[i + 1];
                ptr++;
                *ptr = receivedData[i + 2];
                ptr++;
                maxRecive -= 3;
                if (maxRecive < 3)
                {
                    // Tell App To Pause
                    Serial.println("pause");
                    Serial.flush();
                    delay(10);

                    // APPEND IN FILE
                    appendData(PICS, MAX_BYTES);

                    delay(10);
                    // set Values
                    maxRecive = MAX_BYTES;
                    ptr = &PICS[0];
                    TOTAL_PARTS++;

                    // Start code to do any thing with PICS array
                    // END code to do any thing with PICS array
                }
            }
            totalBytes += len;
            totalChunks++;
            delay(200);
            Serial.println(len);
            delay(10);
        }
    }
    LAST_RECIVED_BYTES = MAX_BYTES - maxRecive;
    if (LAST_RECIVED_BYTES == 0)
    {
        LAST_RECIVED_BYTES = MAX_BYTES;
    }
    verifyDataThatRecived(totalImages, totalBytes);
}

void verifyDataThatRecived(int reciveImages, int reciveBytes)
{
    // Code that will check data is correct or not
    if (reciveBytes == ONE_PIC_SIZE * reciveImages)
    {
        Serial.println("Date Recived Completed");
        delay(5);
        TOTAL_IMAGES = reciveImages;
    }
    else
    {
        delay(10);
        // deleteFile(filename);
        Serial.println("Invalid Data Recived ");
        TOTAL_IMAGES = 0;
        delay(5);
    }
}

//------------ CODE FOR DISPLAYING STORED DATA IN ARRAY
void displayPic()
{
    // Re-open the file for reading:
    openFile();

    if (myFile)
    {
        // Serial.println(filename + String(" content:"));
        // Read and display the file contents:
        int no = 1;
        byte byte1;
        byte byte2;
        byte byte3;
        FastLED.clear();
        for (int i = 0; i < NUM_LEDS && myFile.available(); i++)
        {
            byte1 = myFile.read();
            byte2 = myFile.read();
            byte3 = myFile.read();
            leds[i] = CRGB(byte1, byte2, byte3);
        }
        FastLED.show();
        delay(100);

        if (!myFile.available())
        {
            closeFile();
        }
    }
    else
    {
        Serial.println("Error File");
        Serial.println(isFileOpen);
    }
}

int value = 0;
void printColor(byte r, byte g, byte b)
{
    value = static_cast<int>(r);
    Serial.print(value);
    delay(5);

    Serial.print("-");
    delay(5);

    value = static_cast<int>(g);
    Serial.print(value);
    delay(5);
    Serial.print("-");
    delay(5);

    value = static_cast<int>(b);
    Serial.print(value);
    delay(5);
    Serial.print(" ");
    delay(5);
}

// SD CARD READING WRITING AND ETC
void initializeSDCard()
{
    Serial.print("Initializing SD card...");

    if (!SD.begin(4))
    {
        Serial.println("initialization failed!");
        while (1)
            ;
    }
    Serial.println("initialization done.");
}
