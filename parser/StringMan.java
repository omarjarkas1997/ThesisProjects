// regex packages
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import java.util.ArrayList;
import java.util.Stack;

public class StringMan {


    public static String getContractNameFromLine(String contractName){
        contractName = contractName.replaceAll("\\{", "");
        String[] contractLineArray = contractName.split(" ");
        return contractLineArray[1];
    }

    public static boolean checkMap(String varaibleLine){
        Pattern versionPattern = Pattern.compile("(?=mapping).*\\s+[\\w+\\s+]+;$");
        Matcher mapCheck = versionPattern.matcher(varaibleLine);
        return mapCheck.find();
    }

    public static boolean checkArray(String varaibleLine){
        Pattern versionPattern = Pattern.compile("(?:uint|address|bool|short|float|double)(?:\\s+.*?)?\\[.*?\\].*?;");
        Matcher mapCheck = versionPattern.matcher(varaibleLine);
        return mapCheck.find();
    }

    public static ArrayList<String> getOrganizedVariables(Stack<String> variablesUnFiltered){
        ArrayList<String> organizedVariables = new ArrayList<String>();
        while(!variablesUnFiltered.isEmpty()){
            String variable = variablesUnFiltered.pop();
            if(checkMap(variable)){
                variable = variable.replaceAll("\\p{Punct}"," ");
                variable = variable.replaceAll("\\s+"," ");
                organizedVariables.add("map "+variable);
            }else if (checkArray(variable)){
                variable = variable.replaceAll("\\p{Punct}"," ");
                variable = variable.replaceAll("\\s+"," ");
                organizedVariables.add("array "+variable);
            } else {
                variable = variable.replaceAll("\\p{Punct}"," ");
                variable = variable.replaceAll("\\s+"," ");
                organizedVariables.add(variable);
            }
        }
        return organizedVariables;
    }

    

    public static ArrayList<String> organizedFunctions(Stack<String> functions){
        ArrayList<String> dafnyFunctions = new ArrayList<>();
        while(!functions.isEmpty()){
            String function = functions.pop();
            function = function.replaceAll("function","method");
            function = function.replaceAll("public","");
            function = function.replaceAll("payable","");
            function = function.replaceAll("\\{","").trim();
            dafnyFunctions.add(function);
        }
        return dafnyFunctions;
    }
public static String getParameters(String line){
        Pattern versionPattern = Pattern.compile("\\((.*?)\\)");
        Matcher versionCheck = versionPattern.matcher(line);
        if(versionCheck.find()){
            System.out.println(versionCheck.group().length());
            if(versionCheck.group().length() > 2){
                String line1 = versionCheck.group().replaceAll("\\(","").replaceAll("\\)","").replaceAll("\\,"," ").replaceAll("\\s+"," ");
                String[] parts = line1.split(" ");
                for(int i =0 ; i < parts.length -1; i+=2){
                    System.out.println("Parts "+parts[i]);
                    String temp;
                    temp = parts[i];
                    parts[i] = parts[i+1];
                    parts[i+1] = temp;
                }
                String paramters = "(";
                for(int i =0 ; i < parts.length; i++){
                    parts[i] = parts[i].replaceAll("_","").trim();
                }
                for(int i =0 ; i < parts.length; i++){
                    System.out.println("Parts1 "+parts[i].replaceAll("_",""));
                    if ( i % 2 == 0){
                        paramters = paramters+" "+parts[i];
                    } else {
                        if( i == parts.length - 1){
                            paramters = paramters+": "+parts[i]+")";
                        } else {
                            paramters = paramters+": "+parts[i].replaceAll("uint","int")+",";
                        }
                    }
                }
                return line.replaceAll("\\((.*?)\\)",paramters);
            }}
        return line;
    }


    public static void swap(String x, String y){
        String temp;
        temp = x;
        x = y;
        y = temp;
    }

    public static ArrayList<String> changeParameters(ArrayList<String> organizedFunctions){
        ArrayList<String> dafnyFunctions = new ArrayList<String>();
        for(int i =0 ; i < organizedFunctions.size(); i++){
            dafnyFunctions.add(getParameters(organizedFunctions.get(i)));
        }
        return dafnyFunctions;
    }
}