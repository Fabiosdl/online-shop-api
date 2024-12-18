package com.fabiolima.online_shop.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class OrderStatusException extends IllegalStateException{
    public OrderStatusException(String message){
        super(message);
    }
}
