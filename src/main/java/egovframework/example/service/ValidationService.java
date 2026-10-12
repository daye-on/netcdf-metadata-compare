package egovframework.example.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import ucar.nc2.Group;
import ucar.nc2.NetcdfFile;
import ucar.nc2.Variable;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class ValidationService {

   @Value("${gems.netcdf.path}")
    private String rootPath;

    public List<String> getDirectoryPath(ArrayList<String> pathArr) {
        String result = getDirPathInfo(pathArr);
        return strToList(result);
    }

    public List<String> getNcGroupInfo(String file){
        return ncGroupInfo(file);
    }

    public List<String> getNcAttributeInfo(ArrayList<String> attrInfo){
        return ncAttributeInfo(attrInfo);
    }

    private String getDirPathInfo(ArrayList<String> sendParam) {
        ArrayList<String> result = new ArrayList<>();

        String subPath = "";
        if(sendParam != null && sendParam.size()>0){
            subPath = String.join("/", sendParam);
        }

        String path = rootPath +"/"+ subPath;
        path = path.replaceAll(" ", "");    // 공백 제거

        File dirPath = new File(path);
        for(File file : dirPath.listFiles()){
            result.add(file.getName());
        }

        return result.toString();
    }

    private List<String> strToList(String str) {
        String result = str.substring(1, str.length() - 1);
        result = result.replaceAll("\"", "");
        List<String> list = Arrays.asList(result.split(","));
        return list;
    }

    private List<String> ncGroupInfo(String file) {
        String ncPath = rootPath +"/"+ file;
        ncPath = ncPath.replaceAll(" ", "");    // 공백 제거

        NetcdfFile netcdfFile = null;
        List<String> result = new ArrayList<>();

        try {
            netcdfFile = NetcdfFile.open(ncPath);
            Group rootGroup = netcdfFile.getRootGroup();
            List<Group> groupList = rootGroup.getGroups();

            for(Group group : groupList) {
                List<Variable>  variableList = group.getVariables();
                variableList.forEach(var -> {
                    result.add(var.getName());
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(netcdfFile != null) try {
                netcdfFile.close();
            } catch (IOException e) {
                System.out.println("Close " + netcdfFile);
            }
        }

        return result;
    }

    private List<String> ncAttributeInfo(ArrayList<String> attrInfo){
        String path = rootPath +"/"+ attrInfo.get(0);
        String ncPath = path.trim();
        String ncGroup = attrInfo.get(1);
        String ncVariable = attrInfo.get(2);

        NetcdfFile netcdfFile = null;
        List<String> ncAttributeList = new ArrayList<>();

        try {
            netcdfFile = NetcdfFile.open(ncPath);
            Variable variable = netcdfFile.findGroup(ncGroup).findVariable(ncVariable);

            ncAttributeList.add(variable.getDataType().toString());
            ncAttributeList.add(variable.getNameAndDimensions());
            ncAttributeList.add(variable.getAttributes().toString());   // 필수 xxx

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if(netcdfFile != null) try {
                netcdfFile.close();
            } catch (IOException e) {
                System.out.println("Close " + netcdfFile);
            }
        }

        return ncAttributeList;
    }
}
