/**
* @author  Omar Jarkas 45981799
/** Packages */
import java.io.File;
import java.io.FileNotFoundException; 
import java.io.IOException; 
import java.io.FileWriter; 
import java.util.Scanner; 
import java.util.ArrayList;
/**
 * Class FileParser
 * This class contains all the functions for parsering data using regex
 */
public class DafnyWriter {
    /** Path of output file */
    private File outputFile;
    /** Contract Name */
    private String contractName;
	/**
	 * Constructor
	 * @param contractFile Contract Name
	 */
    public DafnyWriter(String contractName){
        this.contractName = contractName;
        this.outputFile = new File("C:\\Users\\User\\Desktop\\UQ\\thesis\\testing\\"+contractName+".dfy");
    }
	/**
	 * Outputing skeletion
	 * @param variablesUnfilered Varibles to be translated on written 
	 * @param finalFunctions Functions to be translated on written 
	 */
    public void dafnySkelton(ArrayList<String> variablesUnfilered, ArrayList<String> finalFunctions) throws IOException{
        FileWriter dafnyWriter = new FileWriter(this.outputFile);
        dafnyWriter.write("include \"./contract.dfy\"\n\n\n\n");
        dafnyWriter.write("class "+contractName+" extends address {\n\n");
        ArrayList<String> variableNames = getVaraibleNames(variablesUnfilered);
        if(variableNames.size() > 0){
            dafnyWriter.write("\n\tghost var Elements: seq<address>\n");
        }
        for(int i =0 ; i < variableNames.size(); i++){
            String temp = "";
            if(variablesUnfilered.get(i).contains("array")){
                String[] parts = variablesUnfilered.get(i).split(" ");
                String varType = parts[1];
                temp = "array<"+varType+">";
            } else if (variablesUnfilered.get(i).contains("map")){
                String[] parts = variablesUnfilered.get(i).split(" ");
                String varType1 = parts[2];
                String varType2 = parts[3];
                temp = "map<"+varType1+","+varType2+">";
            }else {
                String[] parts = variablesUnfilered.get(i).split(" ");
                String varType1 = parts[0];
                temp = varType1;
            }
            dafnyWriter.write("\n\tvar "+variableNames.get(i)+": "+temp.replace("uint","int").replace("uint256","int")+"\n");
        }
        dafnyWriter.write("\n\tghost var Repr1: set<object>\n");
        dafnyWriter.write("\n\tpredicate Invariant()\n");
        dafnyWriter.write("\t\treads this, Repr1\n");
        dafnyWriter.write("\t\tensures Invariant() ==> Valid() && this in this.Repr1");
        dafnyWriter.write("\t{\n");
        dafnyWriter.write("\t\tthis in this.Repr1 && this.msg in this.Repr1 && \n");
        dafnyWriter.write("\t\tthis !in this.msg.Repr && block in Repr1 && this !in block.Repr\n");
        dafnyWriter.write("\t}\n");
        for(int i =0 ; i < finalFunctions.size(); i++){
            if(finalFunctions.get(i).contains("constructor")){
                dafnyWriter.write("\n\t"+finalFunctions.get(i).replace("uint","int")+"\n");
                /** Constructor's Post Condition */
                String constructorPostCon = "\t\tensures ";
                finalFunctions.remove(i);
            }
        }
        for(int i =0 ; i < finalFunctions.size(); i++){
            dafnyWriter.write("\n\t"+finalFunctions.get(i).replace("(bool)","(r:bool)").replace("(uint)","(r:int)").replace("view","").replace(" private ","").replace("(address[])","(r:address)").replace("modifier","method")+"\n");
            dafnyWriter.write("\t\trequires Invariant()\n");
            dafnyWriter.write("\t\tmodifies Repr, this\n");
            dafnyWriter.write("\t\tensures Invariant() && fresh(Repr-old(Repr))\n");
        }
        dafnyWriter.write("}");
        dafnyWriter.close();
    }
    public ArrayList<String> getVaraibleNames(ArrayList<String> variablesUnfilered){
        ArrayList<String> variableNames = new ArrayList<String>();
        for(int i =0 ; i < variablesUnfilered.size(); i++){
            String[] parts = variablesUnfilered.get(i).split(" ");
            String lastWord = parts[parts.length - 1];
            variableNames.add(lastWord);
        }
        return variableNames;
    }
}
/** Create the Dafny Contract Skeleton */