package egovframework.example.controller;

import egovframework.example.service.ValidationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final ValidationService validationService;

    @GetMapping(value = "/")
    public String init(Model model) {
        List<String> initPath = this.getPathInfo(null);
        model.addAttribute("initPath", initPath);
        return "gems_17";
    }

    @PostMapping(value="/getPathInfo")
    public @ResponseBody List<String> getPathInfo(@RequestParam("path[]") ArrayList<String> pathInfo) {
        return validationService.getDirectoryPath(pathInfo);
    }

    @PostMapping(value="/getNcGroupInfo")
    public @ResponseBody List<String> getNcGroupInfo(@RequestParam("pathUrl") String file) {
        return validationService.getNcGroupInfo(file);
    }

    @PostMapping(value="/getNcAttributeInfo")
    public @ResponseBody List<String> getNcAttributeInfo(@RequestParam("param[]") ArrayList<String> param) {
        return validationService.getNcAttributeInfo(param);
    }
}