
/* import the code libraries needed */
import java.io.*;
import java.nio.charset.Charset;
import java.net.*;
import java.util.logging.*;


/* ********************************************************************************************
 * ********************************************************************************************
 * Program Description: (Listen.java) 
 * In its current form, this program listens for connections on UDP Port 514.
 * When a connection is received, it splits the data into segments using the "|" symbol as
 * a deliminator and prints it out on the screen.
 *
 * You must configure the SMC to forward logs to the server hosting this program AND the
 * port specified in the SMC log forwarding config must match the port specified in this
 * program below (See variable UDP_PORT)
 *
 * There are two code blocks included in the program below. The first portion is commented
 * out at the moment, and only processes a single connection before exiting. The second 
 * portion processes connections repeatedly until the program is killed. It's only 
 * necessary to use one of these code segments at a time, so make sure to comment out the
 * one you're not using. I tend to use the first part for testing, while the second part
 * is for "production." Hence I only place comments in the first part to keep the production
 * code clean for now. Therefore if you want to see code comments refer to the first block.
 *
 * REMINDER: If you make any changes to the code below you must recompile the program for
 * the changes to take effect (See below for instructions on how-to compile.)
 * *******************************************************************************************
 * *******************************************************************************************
 * To install java:
 * Linux (Debian/Ubuntu):
 * > sudo apt-get install openjdk-8-jdk
 *
 * Windows: Go to 
 * http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html 
 * and install the appropriate JDK version
 * *******************************************************************************************
 * *******************************************************************************************
 * To compile: 
 * cd to where the file is stored and type:
 * > javac Listen.java   
 * If succesful, no output will be printed. A file called Listen.class will appear in the 
 * directory where the command was executed.
 * If unsuccessful, a list of compilation errors will be shown.
 * *******************************************************************************************
 * *******************************************************************************************
 * To run: 
 * Linux: cd to where the .class file is stored and type:
 * > sudo java Listen
 * You must run this command with sudo (or as root) since this program attempts to use a
 * reserved port (UDP 514.) If you don't want to run it as root, change the port to
 * something higher (note: you must tell the SMC to forward logs on that port.)
 * The program will crash and you'll get an error if you don't do this.
 *
 * Windows: Run cmd as Administrator and cd to where the .class file is stored. Type:
 * > java Listen
 * You must run this command as an Admin or it will fail/crash.
 * *******************************************************************************************
 */
public class Listen {

    // set the port number to be used
    private static final int UDP_PORT = 514;

    // These variables are for logging errors
    private static final Logger audit = Logger.getLogger("requests");
    private static final Logger errors = Logger.getLogger("errors");


    public static void main(String[] args) {
    
        /* // Use this code to open a socket and process and single connection and then close.
         * // I use this code segment for testing.
        try (DatagramSocket socket = new DatagramSocket(UDP_PORT)) {                  // open a datagram socket to listen on UDP_PORT
            try {
                DatagramPacket request = new DatagramPacket(new byte[1024], 0, 1024); // data will be read into the variable "request"
                socket.receive(request);                                              // server will wait here until a connection is opened by a client
               
                // use "new String(request.getData())" to transform data from byte-form into String-form (easier to read and process)
                String data = new String(request.getData());
                // split the data into segments using the '|' symbol as a deliminator
                String[] datasplit = data.split("\\|");

                //System.out.println(data); // print all of the data at once
                
                // print each data segment individually
                for (int i = 0; i < datasplit.length; i++) {
                    System.out.println("data[" + i + "] = " + datasplit[i]);
                }
            } catch (IOException | RuntimeException ex)i {                            // catch and process errors
                errors.log(Level.SEVERE, ex.getMessage(), ex);
            }
          // the connection is closed automatically at this stage
        } catch (IOException ex) {                                                    // catch and process socket errors; close the socket
            errors.log(Level.SEVERE, ex.getMessage(), ex);
        }

       */


        
        /* Use this code to open a socket and process connections repeatedly. */
        try (DatagramSocket socket = new DatagramSocket(UDP_PORT)) {
            while (true) {
                try {
                    DatagramPacket request = new DatagramPacket(new byte[1024], 0, 1024);
                    socket.receive(request);
               
                    String data = new String(request.getData());
                    String[] datasplit = data.split("\\|");

                    //System.out.println(data);
                
                    for (int i = 0; i < datasplit.length; i++) {
                        System.out.println("data[" + i + "] = " + datasplit[i]);
                    }
                } catch (IOException | RuntimeException ex) {
                    errors.log(Level.SEVERE, ex.getMessage(), ex);
                }
            }
        } catch (IOException ex) {
            errors.log(Level.SEVERE, ex.getMessage(), ex);
        }

    }
}
