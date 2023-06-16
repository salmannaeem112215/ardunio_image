int led1 = 11;
int led2 = 12;
int led3 = 13;

int height = 0;
int width = 0;
int imago = 0;
byte dataa[16 * 16 * 3];
bool uploaded = false;

void setup()
{
    Serial.begin(9600);
    pinMode(led1, OUTPUT);
    pinMode(led2, OUTPUT);
    pinMode(led3, OUTPUT);
}

int avl = 0;

void loop()
{

    if (Serial.available())
    {
        char command = Serial.read();
        if (command == 'A')
        {
            turnLightOn(led1);
        }
        else if (command == 'B')
        {
            turnLightOff(led1);
        }
        if (command == 'C')
        {
            turnLightOn(led2);
        }
        else if (command == 'D')
        {
            turnLightOff(led2);
        }
        if (command == 'E')
        {
            turnLightOn(led3);
        }
        else if (command == 'F')
        {
            turnLightOff(led3);
        }
        else if (command == 'U')
        {
          imageUpload();
          
        }
    }
}

void turnLightOn(int led)
{
    digitalWrite(led, HIGH); // Turn  on the LED
    Serial.println("LED is ON");
}
void turnLightOff(int led)
{
    digitalWrite(led, LOW); // Turn off the LED
    Serial.println("LED is OFF");
}
const int PAYLOAD = 60;
void imageUpload()
{
    byte receivedData[PAYLOAD];
    int len = 0; 
    Serial.print("Stated"); 
    while (true)
    {
        delay(200);
        len = Serial.available();
        if(len>0){
          if(len>=60){
            Serial.readBytes(receivedData, 60);
            for(int i=0;i<60;i+=3){
              // Serial.print(receivedData[i]);
              // Serial.print("-");
              // Serial.print(receivedData[i+1]);
              // Serial.print("-");
              // Serial.print(receivedData[i+2]);
              // Serial.print(" ");
              receivedData[i]=0;
              receivedData[i+1]=0;
              receivedData[i+2]=0;
            }
              // Serial.println("");
          }
          else{
            Serial.readBytes(receivedData,len);
             if(len>3){
              for(int i=0;i<len;i+=3){
                Serial.print(receivedData[i]);
                Serial.print("-");
                Serial.print(receivedData[i+1]);
                Serial.print("-");
                Serial.print(receivedData[i+2]);
                receivedData[i]=0;
                receivedData[i+1]=0;
                receivedData[i+2]=0;
                Serial.print(" ");
                if(i+3+1==len && receivedData[i+3]=='\n'){
                  
                  Serial.println("That's All");
                  receivedData[i+3]=0;
                  break;
                }
              }
             }
             else{
               if(receivedData[0]=='\n'){
                 Serial.println("");
                 Serial.print("\n found break");
               }
             }

            }
            
          }


        // len = Serial.available();
        // if (len > 0)
        // {
        //   char command = Serial.read();
        //   Serial.println(command);
        //     if (len >= 63)
        //     {
        //         Serial.println("chunk");
        //     }
            

        //     else
        //     {
        //         Serial.println("end-chunk");
        //         // break;
        //     }
        // }
        // delay(1000);
        //         turnLightOff(led3);

    }
    //  turnLightOff(led2);
    Serial.print("ENDED ");       

}




// Determine the number of available bytes
        // int availableBytes = Serial.available();

        // // Create an array to store the received data
        // byte receivedData[availableBytes];

        // // Read all available bytes into the array
        // Serial.readBytes(receivedData, availableBytes);

        // Serial.println(avaliableBytes);
        // byte r = 0;
        // byte g = 0;
        // byte b = 0;
        // int index=0;
        // imago = Serial.read();
        // delay(10);

        // height = Serial.read();
        // delay(10);
        // width = Serial.read();
        // delay(10);

        // for (int i = 0; i < imago; i++) {
        //   for (int j = 0; j < height; j++) {
        //     for (int k = 0; k < width; k++) {
        //       int index = (i * height * width * 3) + (j * width * 3) + (k * 3);
        //       dataa[index] = Serial.read();
        //       dataa[index+1] = Serial.read();
        //       dataa[index+2] = Serial.read();
        //     }
        //   }
        // }

        // for (int i = 0; i < imago; i++) {
        //   Serial.print('Image :');
        //   delay(10);
        //   Serial.println(i+1);
        //   delay(10);

        //   for (int j = 0; j < height; j++) {
        //     for (int k = 0; k < width; k++) {
        //       int index = (i * height * width * 3) + (j * width * 3) + (k * 3);
        //       Serial.print(dataa[index]);
        //       delay(10);
        //       Serial.print(dataa[index+1]);
        //       delay(10);
        //       Serial.print(dataa[index+2]);
        //       delay(10);
        //       Serial.print("  ");
        //     }
        //       Serial.println("");
        //   }
        // }