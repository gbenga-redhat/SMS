package com.sms.entity;

public class SMS {


    private Integer id;
    private String createdTimeStamp;
    private String timeStamp;
    private String text;

    public SMS(Integer id, String createdTimeStamp, String timeStamp, String text) {
        this.id = id;
        this.createdTimeStamp = createdTimeStamp;
        this.timeStamp = timeStamp;
        this.text = text;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCreatedTimeStamp() {
        return createdTimeStamp;
    }

    public void setCreatedTimeStamp(String createdTimeStamp) {
        this.createdTimeStamp = createdTimeStamp;
    }

    public String getTimeStamp() {
        return timeStamp;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public void setTimeStamp(String timeStamp) {
        this.timeStamp = timeStamp;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "SMS{" +
                "id=" + id +
                ", createdTimeStamp='" + createdTimeStamp + '\'' +
                ", timeStamp='" + timeStamp + '\'' +
                ", text='" + text + '\'' +
                '}';
    }
}
