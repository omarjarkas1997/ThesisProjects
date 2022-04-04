/**
* @author  Omar Jarkas 45981799
/** Packages */
import java.io.File; 
import java.io.FileNotFoundException;
import java.io.IOException; 
import java.util.Scanner; 
import java.io.FileWriter;   
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Stack;
import java.util.ArrayList;
/**
 * Class FileParser
 * This class contains all the functions for parsering data using regex
 */
class FileParser {
	/**
	 * Getting the contract version
	 * @param contractFile Contract Name
	 */
    public static String getContractVersion(File contractFile) throws FileNotFoundException{
        Scanner contract = new Scanner(contractFile);
        Pattern versionPattern = Pattern.compile("\\bpragma solidity (\\p{Punct}\\d{1,4}.\\d{1,4}.22;)");
        while(contract.hasNextLine()){
            String line = contract.nextLine();
            Matcher versionCheck = versionPattern.matcher(line);
            if(versionCheck.find()){
                return versionCheck.group();
            }
        }
        return "Contract Version is either not found in incompatible with the parser!";
    }
	/**
	 * Getting the contract functions
	 * @param contractFile Contract Name
	 */
    public static Stack<String> getAllFunctions(File contractFile) throws FileNotFoundException {
        Scanner contract = new Scanner(contractFile);
        Pattern versionPattern = Pattern.compile("(?:(\\w+(?:\\.\\w+)*)\\s*=\\s*)?(constructor|function|modifier)\\s*(.*?)\\(");
        Stack<String> functions = new Stack<>();
        while(contract.hasNextLine()){
            String line = contract.nextLine();
            Matcher versionCheck = versionPattern.matcher(line);
            if(versionCheck.find()){
                functions.push(line.trim());
            }
        }
        return functions;
    }
	/**
	 * Getting the contract name
	 * @param contractFile Contract Name
	 */
    public static String getContractNameLine(File contractFile) throws FileNotFoundException {
        Scanner contract = new Scanner(contractFile);
        Pattern versionPattern = Pattern.compile("(?:(\\w+(?:\\.\\w+)*)\\s*=\\s*)?(contract)\\s*(.*?)\\w\\s*(.*?)\\{");
        while(contract.hasNextLine()){
            String line = contract.nextLine();
            Matcher versionCheck = versionPattern.matcher(line);
            if(versionCheck.find()){
                return versionCheck.group();
            }
        }
        return "Contract Name not found!!!!";
    }
	/**
	 * Getting the contract varaibles
	 * @param contractFile Contract Name
	 */
    public static Stack<String> getVaraibles(File contractFile) throws FileNotFoundException {
        Scanner contract = new Scanner(contractFile);
        Pattern versionPattern = Pattern.compile("(?=address|uint|mapping|bool).*\\s+[\\w+\\s+]+;$");
        Stack<String> variables = new Stack<>();
        while(contract.hasNextLine()){
            String line = contract.nextLine();
            Matcher versionCheck = versionPattern.matcher(line);
            if(versionCheck.find()){
                line = line.trim();
                variables.push(line);
            }
        }
        return variables;
    }
	/**
	 * Removing all comments
	 * @param contractFile Contract Name
	 */
    public static File removeCommentsAndCreateTestFile(File contractFile) throws IOException {
        Scanner contract = new Scanner(contractFile);
        File myObj = new File("C:\\Users\\User\\Desktop\\UQ\\thesis\\testing\\Lottery.test");
        FileWriter myWriter = new FileWriter(myObj);
        if (myObj.createNewFile()) {
            System.out.println("File created: " + myObj.getName());
          } else {
            System.out.println("File already exists.");
          }        
        while(contract.hasNextLine()){
            String line = contract.nextLine().replaceAll("(?:/\\*(?:[^*]|(?:\\*+[^*/]))*\\*+/)|(?://.*)","");
            myWriter.write(line+"\n");
        }
        myWriter.close();
        return myObj;
    }
}