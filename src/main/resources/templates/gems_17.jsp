<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>Main</title>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <link id="contextPathHolder" th:data-contextPath="${#httpServletRequest.getContextPath()}"/>

    <!-- bootstrap -->
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <link rel="stylesheet" type="text/css" th:href="@{/css/bootstrap/bootstrap.css}">
    <script type="text/javascript" th:src="@{/js/bootstrap/bootstrap.bundle.js}"></script>

    <!-- js tree -->
    <link rel="stylesheet" th:href="@{jstree/themes/default/style.min.css}"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" />

    <!-- egovframe 제공
    <link rel="stylesheet" type="text/css" th:href="@{/css/egovframework/sample.css}">
    <script type="text/javascript" th:src="@{/js/egovframework/jquery-3.6.1.min.js}"></script>-->
</head>
<body>
<div class="p-2">
    <div>
        <div id="select_satellite">
            <select id="path_satellite" class="w-100 mb-1">
                <option value="">위성 선택</option>
                <option th:each="path: ${initPath}" th:text="${path}" th:value="${path}"></option>
            </select>
        </div>
        <div id="select_version" class="d-flex w-100">
            <select id="path_version_1" class="w-50 mb-1 me-1">
                <option value="">선택</option>
            </select>
            <select id="path_version_2" class="w-50 mb-1">
                <option value="">선택</option>
            </select>
        </div>
        <div id="select_file" class="d-flex w-100">
            <select id="file_1" class="w-50 mb-1 me-1">
                <option value="">선택</option>
            </select>
            <select id="file_2" class="w-50 mb-1">
                <option value="">선택</option>
            </select>
        </div>
    </div>
    <div class="d-flex justify-content-between">
        <div>
            <input type="checkbox" id="isSameFile"/>
            <label for="isSameFile">동일 파일 비교하기</label>
        </div>
        <div>
            <input type="button" value="초기화" id="reload"/>
            <input type="button" value="불러오기" id="validate"/>
        </div>
    </div>
</div>
<div class="d-flex w-100">
    <div id="dirTree1" class="w-25 mb-1 me-1"></div>
    <div id="dirTree1_attr" class="w-25 mb-1 me-1"></div>
    <div id="dirTree2" class="w-25 mb-1 me-1"></div>
    <div id="dirTree2_attr" class="w-25 mb-1 me-2"></div>
</div>
<script src="jstree/jstree.min.js"></script>
<script th:inline="javascript">
    $(document).ready(function () {
        document.querySelector("#path_satellite").addEventListener("change", event => {
            // 변경 시 드롭다운 & js tree 초기화
            $("[id^='path_version_']").empty()
            $("[id^='path_version_']").append("<option value=''>선택</option>")
            $("[id^='file_']").empty()
            $("[id^='file_']").append("<option value=''>선택</option>")
            $("[id^='dirTree']").jstree("destroy").empty();

            const pathArr = []
            pathArr.push(event.target.value)

            $.ajax({
                type: "POST"
                , url: "/getPathInfo"
                , data: {
                    path: pathArr
                }, success: function (result) {
                    $.each(result, function () {
                        $("[id^=path_version_]").append("<option>"+this+"</option>")
                    })
                }
            })
        });

        document.querySelector("#path_version_1").addEventListener("change", event => {
            // 변경 시 하위 디렉토리 드롭다운 초기화
            $("#file_1").empty()
            $("#file_1").append("<option value=''>선택</option>")

            // 상위 디렉토리 정보 참조
            const pathArr = []
            const preValue = $("#path_satellite option:selected").text()
            pathArr.push(preValue)
            pathArr.push(event.target.value)

            $.ajax({
                type: "POST"
                , url: "/getPathInfo"
                , data: {
                    path: pathArr
                }, success: function (result) {
                    $.each(result, function () {
                        $("#file_1").append("<option>"+this+"</option>")
                    })
                }
            })
        });

        document.querySelector("#path_version_2").addEventListener("change", event => {
            // 변경 시 하위 디렉토리 드롭다운 초기화
            $("#file_2").empty()
            $("#file_2").append("<option value=''>선택</option>")

            // 상위 디렉토리 정보 참조
            const pathArr = []
            const preValue = $("#path_satellite option:selected").text()
            pathArr.push(preValue)
            pathArr.push(event.target.value)

            $.ajax({
                type: "POST"
                , url: "/getPathInfo"
                , data: {
                    path: pathArr
                }, success: function (result) {
                    $.each(result, function () {
                        $("#file_2").append("<option>"+this+"</option>")
                    })

                    // 동일 파일 체크한 상태에서 버전2 수정하면, 체크 비활성화(재선택)
                    const isSameFile = document.querySelector("#isSameFile").checked;
                    if(isSameFile) {
                        document.querySelector("#isSameFile").checked = false;
                        document.querySelector("#file_2").disabled = false;
                    }
                }
            })
        });

        document.querySelector("#file_1").addEventListener("change", event => {
            const isSameFile = document.querySelector("#isSameFile").checked;
            if(isSameFile){
                const file2Option = document.querySelector("#file_2").options;
                for(let i=0; i<file2Option.length; i++) {
                    if (file2Option[i].value === event.target.value) {
                        file2Option[i].selected = true;
                    }
                }
            }
        });

        document.querySelector("#isSameFile").addEventListener("change", event => {
            const checked = event.target.checked;
            if(checked) {
                const file1Value = document.querySelector("#file_1").value;
                const file2Option = document.querySelector("#file_2").options;
                for(let i=0; i<file2Option.length; i++) {
                    if (file2Option[i].value === file1Value) {
                        file2Option[i].selected = true;
                    }
                }
                document.querySelector("#file_2").disabled = true;
            } else {
                document.querySelector("#file_2").disabled = false;
            }
        });

        document.getElementById("reload").addEventListener("click", event => {
            window.location.reload();
        })

        document.getElementById("validate").addEventListener("click", event => {
            const satellite = $("#path_satellite option:selected").val();
            const version1 = $("#path_version_1 option:selected").val();
            const version2 = $("#path_version_2 option:selected").val();
            const file1 = $("#file_1 option:selected").val();
            const file2 = $("#file_2 option:selected").val();

            const filesInfo = []
            filesInfo.push(satellite)
            filesInfo.push(version1)
            filesInfo.push(version2)
            filesInfo.push(file1)
            filesInfo.push(file2)

            if(file1 == 0 || file2 == 0){
                alert("파일을 선택 후 버튼을 눌러주세요.")
            } else {
                getNcGroupData(filesInfo)
            }
        })

        function getNcGroupData(pathArr) {
            const file1_path = pathArr[0]+"/"+pathArr[1]+"/"+pathArr[3]
            let file1_groupNameArr = [];
            const file1_variableNameArr = [];

            $.ajax({
                type: "POST"
                , url: "/getNcGroupInfo"
                , async: false
                , data: {
                    pathUrl: file1_path
                }, success: function (result) {
                    const groupNameArr_raw = [];
                    $.each(result, function (key, value) {
                        const strSplit = value.split("/")
                        groupNameArr_raw.push(strSplit[0])
                        file1_variableNameArr.push(value)
                    })
                    file1_groupNameArr = [...new Set(groupNameArr_raw)]
                }
            })

            const file2_path = pathArr[0]+"/"+pathArr[2]+"/"+pathArr[4]
            let file2_groupNameArr = [];
            const file2_variableNameArr = [];

            $.ajax({
                type: "POST"
                , url: "/getNcGroupInfo"
                , async: false
                , data: {
                    pathUrl: file2_path
                }, success: function (result) {
                    const groupNameArr_raw = [];
                    $.each(result, function (key, value) {
                        const strSplit = value.split("/")
                        groupNameArr_raw.push(strSplit[0])
                        file2_variableNameArr.push(value)
                    })
                    file2_groupNameArr = [...new Set(groupNameArr_raw)]
                }
            })

            const varDiff = symmetricDiff(file1_variableNameArr, file2_variableNameArr)

            setJsTree("dirTree1", file1_path, file1_groupNameArr, file1_variableNameArr, varDiff)
            setJsTree("dirTree2", file2_path, file2_groupNameArr, file2_variableNameArr, varDiff)
        }

        // 대칭차집합
        function symmetricDiff(arr1, arr2) {
            let difference = arr1
                .filter(x => !arr2.includes(x))
                .concat(arr2.filter(x => !arr1.includes(x)));

            return difference
        }

        function setJsTree(divId, filePath, groupName, variableName, diff, test) {
            const ncTree = new Array();
            const groupSize = groupName.length
            const variableSize = variableName.length
            const fileName = filePath.substring(filePath.lastIndexOf("/")+1)

            // group
            $.each(groupName, function (index, value) {
                ncTree[index] = {"id": value, "parent":"root", "text":value, "type":"groupType", "state":{opened: true}}
            })

            // variable
            for(let i=0; i<variableSize; i++){
                const index = groupSize+i
                const variable = variableName[i]
                const parent = variable.split("/")[0]
                const value = variable.split("/")[1]

                if(diff.includes(variable)){
                    ncTree[index] = {"id": value, "parent":parent, "text":value, "type":"valueWithColor"}
                } else {
                    ncTree[index] = {"id": value, "parent":parent, "text":value, "type":"value"}
                }
            }

            // root
            const rootIndex = groupSize+variableSize
            ncTree[rootIndex] = {"id": "root", "parent":"#", "text":fileName, "type":"rootType"
                , "state": {opened: true, selected: false}};

            $("#"+divId).jstree("destroy").empty();
            $("#"+divId).jstree({
                "core": {
                    "data": ncTree
                },
                "types" : {
                    "rootType" : {
                        "icon" : "fa-solid fa-folder-open"
                    },
                    "groupType" : {
                        "icon" : "fa-solid fa-file"
                    },
                    "value": {
                        "icon" : "fa-solid fa-file-lines"
                    },
                    "valueWithColor" : {
                        "icon" : "fa-solid fa-file-lines",
                        "a_attr":{style: "background:#fff9c4;"} // 노란색
                    }
                },
                "plugins": ["wholerow", "types"]
            })

            $("#"+divId).jstree("refresh")
            $("#"+divId).bind("select_node.jstree", function (e, data) {
                // console.log(data.node.parent)
                // console.log(data.node.type)
                // console.log(data.node.id)

                const currentType = data.node.type;
                const ncInfo = new Array();

                if(currentType.includes("value")){
                    ncInfo.push(filePath.trim())    // path
                    ncInfo.push(data.node.parent);  // group
                    ncInfo.push(data.node.id);      // variable
                    getNcAttributeData(divId, ncInfo)
                }
            })
        }

        function getNcAttributeData(divId, sendData) {
            const currentDiv = divId+"_attr";

            $.ajax({
                type: "POST"
                , url: "/getNcAttributeInfo"
                , data: {
                    param: sendData
                }
                , success: function (result) {
                    const customHtml = "<div class='m-2 p-1 border border-opacity-50'><p>"+result[0]+" "+result[1]+"</p><p>"+result[2]+"</p></div>"
                    $("#"+currentDiv).html(customHtml)
                }
            })
        }
    })
</script>
</body>
</html>