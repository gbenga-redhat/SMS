package com.sms.rest;


import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sms.entity.GenericResult;
import com.sms.entity.SMS;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class SMSController {
    private Map<Integer, SMS> smss;
    private int maxSMS;
    public SMSController() {
        super();
        smss = new HashMap<Integer, SMS>();
        for(int i = 1; i< 4; i++){
            long ts = System.currentTimeMillis();
            SMS sms = new SMS(i, "44750088776"+i, "44750089776"+(i+4), "Some random SMS Character text "+i);
            smss.put(i, sms);
            maxSMS=i;
        }
    }

    @RequestMapping("/")
    @ResponseBody
    String home() {
        return "Hello World Pipeline!";
    }

    @RequestMapping(value="/sms/v2/{id}", method=RequestMethod.GET, produces="application/json")
    public @ResponseBody SMS getSMS(@PathVariable("id") Integer id, HttpServletRequest request, HttpServletResponse response) {

        SMS toReturn = null;
        if(smss.get(id)!=null){
            response.setStatus(200);
            toReturn =  smss.get(id);
            toReturn.setTimeStamp(""+ System.currentTimeMillis());
            return toReturn;
        }

        response.setStatus(404);
        return null;

    }


    @RequestMapping(value="/sms/v2", method=RequestMethod.POST, produces="application/json", consumes="application/json")
    public @ResponseBody SMS postProduct(@RequestBody SMS sms, HttpServletResponse response) {

        response.setStatus(201);
        sms.setId(++maxSMS);
        smss.put(maxSMS, sms);
        return sms;

    }


    @RequestMapping(value="/sms/v2/{id}", method=RequestMethod.PUT, produces="application/json", consumes="application/json")
    public @ResponseBody SMS putProduct(@PathVariable("id") Integer id, @RequestBody SMS sms, HttpServletResponse response) {

        response.setStatus(204);
        sms.setId(id);
        smss.put(id, sms);
        return sms;

    }


    @RequestMapping(value="/sms/v2/{id}", method=RequestMethod.DELETE, produces="application/json")
    public @ResponseBody
    GenericResult deleteProduct(@PathVariable("id") Integer id, HttpServletResponse response) {

        if(smss.containsKey(id) && smss.remove(id)!=null){
            response.setStatus(204);
            return new GenericResult("SMS "+id+" successfully deleted");
        }

        response.setStatus(404);
        return new GenericResult("SMS "+id+" NOT FOUND");

    }



}
