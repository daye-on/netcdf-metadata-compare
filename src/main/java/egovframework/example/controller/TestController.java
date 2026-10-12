package egovframework.example.controller;

import egovframework.example.service.ValidationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class TestController {

    private final ValidationService validationService;

    @PostMapping(value="/postmanTest")
    public String ncfile(@RequestBody String pathUrl){
        System.out.println("controller check, "+pathUrl);
        List<String> result = validationService.getNcGroupInfo(pathUrl.replace("pathUrl=", ""));

        System.out.println("controller check, ");
        result.forEach(System.out::println);
        return null;
    }
}
