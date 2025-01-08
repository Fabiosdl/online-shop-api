package com.fabiolima.online_shop.service;

import com.fabiolima.online_shop.model.BasketItem;
import com.fabiolima.online_shop.model.Product;

import java.util.List;

public interface BasketItemService {

    BasketItem addItemToBasket(Long basketId, Long productId, int quantity);
    List<BasketItem> getItemsByBasket(Long basketId);
    BasketItem getItemById(Long basketItemId);
    BasketItem updateBasketItem(Long basketId, Long basketItemId, int newQuantity);
    BasketItem removeItemFromBasket(Long basketId, Long basketItemId);

    BasketItem incrementItemQuantity(Long basketItemId);
    BasketItem decrementItemQuantity(Long basketId, Long basketItemId);

    void ensureStockAvailable(Product product, int quantity);

    double calculateItemTotalPrice(Long basketItemId);
}