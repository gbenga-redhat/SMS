package com.sms.entity;

public class GenericResult {
    private String result;

    public GenericResult(String result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return "GenericResult{" +
                "result='" + result + '\'' +
                '}';
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}
