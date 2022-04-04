// regex packages
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class SyntaxChecker {

    public static Boolean checkContractVersion(String contractVersion){
        Pattern versionPattern = Pattern.compile("\\bpragma solidity (\\p{Punct}\\d{1,4}.\\d{1,4}.22;)");
        Matcher versionCheck = versionPattern.matcher(contractVersion);
        return versionCheck.find();
    }

    public static Boolean checkContractName(String contractVersion){
        Pattern versionPattern = Pattern.compile("\\w+");
        Matcher versionCheck = versionPattern.matcher(contractVersion);
        return versionCheck.find();
    }

    public static String testingRegex(String contractVersion){
        Pattern versionPattern = Pattern.compile("(?:(?:contract)\\s+\\w+(\\s)?)*");
        Matcher versionCheck = versionPattern.matcher(contractVersion);
        if(versionCheck.find()){
            return versionCheck.group();
        }
        return "";
    }

    

}

// (?:(?:function|construcor)+\s+)+[$_\w<>\[\]\s]*\s+[\$_\w]+\([^\)]*\)?\s*\{?[^\}]*\}?