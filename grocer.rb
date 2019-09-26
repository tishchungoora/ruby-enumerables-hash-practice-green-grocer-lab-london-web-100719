### CONSOLIDATE CART METHOD

def consolidate_cart(cart)
  cart_as_hash = {}
  
  # Go through each element of the cart array and also go down to the level where we are able to work with the key-value pairs within each array element
  cart.each do |items|
    items.each do |name, attributes|
      
      # If cart_as_hash doesn't already hold a particular item, add it to the hash and merge a new attribute to identify the unique count of that item
      if !cart_as_hash.has_key?(name)
        cart_as_hash[name] = attributes.merge(:count => 1)
        
      # Otherwise, if that item is already present then simply augment the count of that item in the hash
      else
        cart_as_hash[name][:count] += 1
      end
    end
  end
  cart_as_hash
end


### APPLY COUPONS METHOD

def apply_coupons(cart, coupons)
  
  # Go through each element of the coupon array
  coupons.each do |i|
    item = i[:item]
    
    # Check if there is a matching item in the cart to which the coupon discount can be applied. Also check if the count of that item in the cart is greater than or equal to the participating number in the coupon
    if cart.has_key?(item) && cart[item][:count] >= i[:num]
        
      # Let's define a variable so that we reduce the amount of typing when we need to refer to the item with coupon
      coupon_item = "#{item} W/COUPON"
        
      # If the cart already holds a coupon item, then augment its count by the corresponding number identified in the coupon array. Also update the count of the existing item in the cart
      if cart[coupon_item]
        cart[coupon_item][:count] += i[:num]
        cart[item][:count] -= i[:num]
          
      # Otherwise create the coupon item in the cart with the appropriate attributes. Also update the count of the existing item in the cart
      else
        cart[coupon_item] = {}
        cart[coupon_item][:price] = i[:cost] / i[:num]
        cart[coupon_item][:clearance] = cart[item][:clearance]
        cart[coupon_item][:count] = i[:num]
        cart[item][:count] -= i[:num]
      end
    end
  end
  cart
end


### APPLY CLEARANCE METHOD

def apply_clearance(cart)
  
  #Go through each key in the cart hash. If clearance applies to the item then update its price so that a 20% discount is applied, rounded to two decimal places
  cart.each_key do |item|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
  cart
end


### CHECKOUT METHOD

def checkout(cart, coupons)
  # Establish in a step-wise way what the final cart looks like
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupons = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(cart_with_coupons)
  
  # Initialize the amount due as zero
  amount_due = 0
  
  # Go through each item in the final cart hash to cummulatively calculate the amount due. The total per item is the product of its price and quantity
  final_cart.each do |item, attributes|
    amount_due += attributes[:price] * attributes[:count]
    
    # If the amount due is greater than 100, apply the 10% discount
    if amount_due > 100
      amount_due = amount_due * 0.9
    end
  end
  amount_due
end