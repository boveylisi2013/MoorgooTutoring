/* Initialize the Stripe and Mailgun Cloud Modules */
var Stripe = require('stripe');
Stripe.initialize('sk_test_hAeudUfbnKDIOKi1hfbvqzRn');
 
var Mailgun = require('mailgun');
Mailgun.initialize("sandbox4b8c300a5c1e429f9057bc2f275e77b0.mailgun.org", "key-db8f09018a867224eac6d425174b7296");
 
 
Parse.Cloud.define("purchase", function(request, response) {
  Parse.Cloud.useMasterKey();
 
  Stripe.Charges.create({
    amount: request.params.price * 100, // expressed in cents
    currency: "usd",
    card: request.params.cardToken // the token id should be sent from the client
  }
  ,
  {
    success: function(httpResponse) {
      response.success("Purchase made!");
    }
    ,
    error: function(httpResponse) {
      response.error("Your transaction can't be completed. Please try again or contact our service representive.");
    }
  });
   
});





Parse.Cloud.define("emailCustomer", function(request, response) {
  Parse.Cloud.useMasterKey();

  // Generate the email body string.
  var body = "We've received and processed your order for the following item: \n\n" + 
             "Item: Moorgoo Tutor Service\n";

  body += "Course: " + request.params.course + "\n" +
                "Date: " + request.params.date + "\n" +
                "Hours: " + request.params.hour + "\n" +
                "Price: " + request.params.price + ".00 dollars\n\n" +
                "Your contact: " + request.params.phone + " (phone) " + request.params.email + " (email) " + 
                "\nWe will arrange your tutor service as soon as possible. " + 
                "Let us know if you have any questions!\n\n" +
                "Thank you,\n" +
                "The Moorgoo Educational Corporation";

  Mailgun.sendEmail({
    to: request.params.email,
    from: 'moorgoo2014@gmail.com',
    subject: 'Your order for Moorgoo tutor was successful!',
    text: body
    }, {
    success: function(httpResponse) {
      console.log(httpResponse);
      response.success("Email sent!");
    },
    error: function(httpResponse) {
      console.error(httpResponse);
      response.error("Uh oh, something went wrong");
    }
  });

});
