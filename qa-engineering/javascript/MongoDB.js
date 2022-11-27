//FIND
{
    loyaltyId: 582743
}

//FIND 2 - WHERE
db.getCollection('MemberFuelSubscriptions').find({
    'active': true
})

//FIND 3 - LIKE + IN
db.getCollection('LoyaltyMembers').find({
    'username': {
        $in: [/@/, '', null]
    },
    'personal.email': {
        $in: [/@/, '', null, /:deleted/]
    }
})

//FIND 4 - NOT EQUAL
db.getCollection('LoyaltyMembers').find({
    'username': {
        $ne: 'kit@made.llc'
    },
    'personal.email': {
        $ne: 'kit@made.llc'
    }
})

//FIND 4 - IN
{
    loyaltyId: {
        $in: [489243, 582743]
    }
} //mongoDB does not use db.Collection()
{
    username: {
        $in: ['kit@made.llc', '8kit@made.llc']
    }
}

//FIND 5 - >&< + SORT
db.getCollection('LoyaltyMembers').find({
    'tier.tierId': {
        $gt: 0
    },
    'tier.tierId': {
        $lt: 2
    }
}).sort({
    'tier.points': -1
})

//FIND 6 - NOT IN
db.getCollection('LoyaltyMembers').find({'personal.email':{ $not:{$in:[/.com/, '', null, /:deleted/]}}, 
    loginType:{ $not:{$in:['facebook', 'Twitter'] } } })

//UPDATE ALL - WHERE
db.getCollection('MemberFuelSubscriptions').update({
    'active': true
}, {
    $set: {
        'active': false
    }
}, {
    multi: true
})

//UPDATE	ALL - IN
db.getCollection('LoyaltyMembers').update({
    'personal.email': {
        $in: [/@/, '', null, /:deleted/]
    }
}, {
    $set: {
        'personal.email': 'kit@made.llc'
    }
}, {
    multi: true
})

db.getCollection('LoyaltyMembers').update({
    'username': {
        $in: [/@/, '', null, /:deleted/]
    }
}, {
    $set: {
        'username': 'kit@made.llc'
    }
}, {
    multi: true
})

db.getCollection('MemberTransactions').update({
    'date': {
        $gt: 1478394001
    }
}, {
    $set: {
        'date': 1478394001
    }
}, {
    multi: true
})

//UPDATE AND REPLACE EMAIL WITH RANDOM STRING (consult with DEV prior to running any updates)
var ops = [];
db.getCollection('LoyaltyMembers').find({'personal.email': {$in: ["test0.7487462862064161@gmail.com"]}}).forEach(function(e, i) {
var afterEmail = ["test"] +  Math.random().toString() + ["@gmail.com"]
db.getCollection('LoyaltyMembers').update(
   {'personal.email': "test0.7487462862064161@gmail.com"},
   {$set: {'personal.email': afterEmail}})
   });
if ( ops.length === 500 ) {
        db.getCollection('LoyaltyMembers').bulkWrite(ops);
        ops = [];
    } 

//----------------------------------------------------------------//
//TESTING	
//----------------------------------------------------------------//

// email template ids
db.getCollection('EmailTemplates').find({"template.emailBody.emailId":40077032788})

// loyalty members
db.getCollection('LoyaltyMembers').find({loyaltyId:
    {$in: [6000382, 6000332, 2095858, 6000293, 6000127, 2095850, 2095900]}});

// store config - qa lab
db.getCollection('RaceTracStoreInfo').find({SID:12003})
db.getCollection('RaceTracStoreStatus').find({storeId:"12003"})

// between dates
db.getCollection('MemberTransactions').find( { $and: 
    [ 
        { date: { $gte: 1606932000} } 
        ,{ date: { $lt: 1606964400} } 
        ,{ loyaltyId: {$in: [6000346, 13]} }
        ,{ gallons: {$ne: 0}}
    ] 
} ).sort({date:-1})

// between dates using ISO for date objects
db.getCollection("MemberFuelSubscriptions")
  .find({
    startDate: {
      $gte: ISODate("2021-02-11T00:00:00Z"),
      $lt: ISODate("2021-02-15T00:00:00Z"),
    },
  })
  .sort({ startDate: -1 });

// fuel rewards
db.getCollection('Rewards').find({desc:{
        $in: [/fuel/, /reward/]
    }})
	
//----------------------------------------------------------------//	
//END TESTING	
//----------------------------------------------------------------//	

// If you need to figure out, for the time being, who a debit card belongs to, you can query the accountNumber property in the MemberAccounts collection in preprod:

db.getCollection('MemberAccounts').find({"memberIds.accountNumber": '639471130000000018'})

db.getCollection('MemberAccounts').find({"memberIds.physicalCardBarCode": 
    {$in: ['639471130000319962', '639471130000319970', '639471130000319982']}
})

// find email template ID
db.getCollection('EmailTemplates').find({"template.emailBody.emailId":40077032788})

// coupon transactions
db.getCollection('MemberTransactions').find({ $and: 
    [ 
        { loyaltyId: {$in: [6000292]} }
        ,{ savedFromCoupons: {$ne: 0}}
    ] 
} ).sort({date:-1})

db.getCollection('MemberDebitCardStatus').find({
        loyaltyId:{$in:[6000567, 6000568, 6000569, 13, 6000291,
        6000341, 6000563, 6000558, 6000451, 6000564, 6000270]}
})