/* Initialize the Stripe and Mailgun Cloud Modules */
var Stripe = require('stripe');
Stripe.initialize('sk_live_T5k8fdyWN2GH9y5eQQjaqZiT');
 
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




//send receipt to the customer
Parse.Cloud.define("emailAfterTransaction", function(request, response) {
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
    from: 'moorgootutor@gmail.com',
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

  // Generate the email body string.
  body = "New costumer has ordered for the following item: \n\n" + "Item: Moorgoo Tutor Service\n";

  body += "Name: " + request.params.firstName +" "+ request.params.lastName + "\n" +
          "Course: " + request.params.course + "\n" +
          "Date: " + request.params.date + "\n" +
          "Hours: " + request.params.hour + "\n" +
          "Price: " + request.params.price + ".00 dollars\n\n" +
          "Contact: " + request.params.phone + " (phone) " + request.params.email + " (email)\n" + 
          "The Moorgoo Educational Corporation";

  Mailgun.sendEmail({
    to: 'moorgootutor@gmail.com',
    from: 'moorgootutor@gmail.com',
    subject: '[Order] New Tutoring Request',
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


//send email to customer representitive with new tutor application
Parse.Cloud.define("registerTutor", function(request, response) {
  Parse.Cloud.useMasterKey();

  /////////////////////////////send to customer seviser
  // Generate the email body string.
  var body = "Dear Moorgoo customer representive:\n" 
           + "     My name is " +request.params.firstName+ " " +request.params.lastName+ ". I am requesting to become an tutor. Please contact me soon.\n\n"

  body += "Email: " + request.params.email + "\n" +
          "First name: " + request.params.firstName + "\n" +
          "Last Name: " + request.params.lastName + "\n" +
          "Phone: " + request.params.phone + "\n" +
          "School: " + request.params.school

  Mailgun.sendEmail({
    to: 'moorgootutor@gmail.com',
    from: request.params.email,
    subject: '[Application] New Tutor Application',
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


  /////////////////////////////send to student///////////////
  var body2 = "Dear " +request.params.firstName+ " " +request.params.lastName+ ",\n"
            + "     We have received your tutor application. What will happen next? Within one week, "
            + "our tutor lead will contact you for more information and schedule an interview. If you have any questions, "
            + "please contact us!\n\n"
            + "Email: moorgootutor@gmail.com\n"
            + "Phone: (858)900-8800\n"
            + "Moorgoo Education Corporation" 

  Mailgun.sendEmail({
    to: request.params.email,
    from: 'moorgootutor@gmail.com',
    subject: 'Moorgoo tutor application',
    text: body2
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
