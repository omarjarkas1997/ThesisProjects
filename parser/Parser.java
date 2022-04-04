/**
* @author  Omar Jarkas 45981799
/** Packages */
import java.io.File; 
import java.io.FileNotFoundException; 
import java.util.Scanner; 
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Stack;
/**
 * Class Parser
 * This class contains the main functions the control the parser
 */
public class Parser {
    public static void main(String[] args) {
        /** Variable to hold the contract's name */
        String contractName;
        /** Variable to hold the contract's version */
        String contractVersion;
        /** Data Structure to hold the map of variables name, values, and types */
        HashMap<String, String> varaiblesMap = new HashMap<String, String>();
        try {
            /** Input the Contrat name here */
            String contractNameInput = args[0];
            /** Class for extracting text from the contract file */
            FileParser fileParser = new FileParser();
            /** Class for checking the syntax of the Contract File using regex */
            SyntaxChecker syntaxChecker = new SyntaxChecker();
            /** First step is to remove all comment as not to interfer with other patterns */
            File contractFileCommented = new File("C:\\Users\\User\\Desktop\\UQ\\thesis\\
                                                    ConToBeProv\\"+contractNameInput+".sol");
            /** Output commentless file */
            File contractFile = fileParser.removeCommentsAndCreateTestFile(contractFileCommented);
            /** Class to Manipulate Strings */
            StringMan stringMan = new StringMan();
            /** Getting contract's verision and placing it in variable */
            contractVersion = fileParser.getContractVersion(contractFile);
            /** Syntax and compatibility check */
            if(syntaxChecker.checkContractVersion(contractVersion)){
                System.out.println("Version "+contractVersion);
            } else {
                System.out.println("Error: Version incompatible against parser!");
                System.exit(1);
            }
            /** Getting Contract's name */
            contractName = fileParser.getContractNameLine(contractFile);
            /** Syntax check of Contract Name*/
            contractName = stringMan.getContractNameFromLine(contractName);
            if(syntaxChecker.checkContractName(contractName)){
                System.out.println(contractName);
            }
            /** Class for constructing the skeletion */
            DafnyWriter dafnyWriter = new DafnyWriter(contractName);
            /** Using the File Parser and StringMan Classes to 
             * Parse and detect all the function declaration of variables and placing them in data strucutres*/
            Stack<String> functions = fileParser.getAllFunctions(contractFile);
            Stack<String> variablesUnFiltered = fileParser.getVaraibles(contractFile);
            ArrayList<String> organizedVariables = stringMan.getOrganizedVariables(variablesUnFiltered);=
            ArrayList<String> filteredFunctions = stringMan.organizedFunctions(functions);
            ArrayList<String> organizedFunctions = stringMan.changeParameters(filteredFunctions);
            /** Output the contract after passing the variables and functions to be written*/
            dafnyWriter.dafnySkelton(organizedVariables, organizedFunctions);
        } catch (Exception e) {
            //TODO: handle exception
            System.out.println("An Error has occured.");
            e.printStackTrace();
        }
    }
}
