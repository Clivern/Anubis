---
title: Django Custom Month and Year Lookup
date: 2019-04-27 00:00:00
featured_image: https://images.unsplash.com/photo-1546526418-6854feb81940?q=90&fm=jpg&w=1000&fit=max
excerpt: Everyone want to keep Django timezone support but sometimes you need to keep your SQL queries a way from timezone conversion especially if by default your application timezone is UTC. Django will do something like this `CONVERT_TZ(`app_incident`.`datetime`, 'UTC', 'UTC'))` and it will return `Null` if the timezone table is empty. Even that conversion is not even needed.
---

![](https://images.unsplash.com/photo-1546526418-6854feb81940?q=90&fm=jpg&w=1000&fit=max)

Everyone want to keep Django timezone support but sometimes you need to keep your SQL queries a way from timezone conversion especially if by default your application timezone is UTC. Django will do something like this `CONVERT_TZ(`app_incident`.`datetime`, 'UTC', 'UTC'))` and it will return `Null` if the timezone table is empty. Even that conversion is not even needed.

On my previous article, I explained how to manage this in case of date comparison [http://clivern.com/django-custom-lookups/](http://clivern.com/django-custom-lookups/). Today, I was trying to do the same for month and year comparison and I created a new lookups.

```
from django.db.models import Lookup
from django.db.models.fields import DateField, DateTimeField


@DateField.register_lookup
@DateTimeField.register_lookup
class YearEqLookup(Lookup):
    lookup_name = 'year_c_eq'

    def as_sql(self, compiler, connection):
        lhs, lhs_params = self.process_lhs(compiler, connection)
        rhs, rhs_params = self.process_rhs(compiler, connection)

        params = lhs_params + rhs_params
        return 'EXTRACT(YEAR FROM DATE(%s)) = EXTRACT(YEAR FROM DATE(%s))' % (lhs, rhs), params


@DateField.register_lookup
@DateTimeField.register_lookup
class MonthEqLookup(Lookup):
    lookup_name = 'month_c_eq'

    def as_sql(self, compiler, connection):
        lhs, lhs_params = self.process_lhs(compiler, connection)
        rhs, rhs_params = self.process_rhs(compiler, connection)

        params = lhs_params + rhs_params
        return 'EXTRACT(MONTH FROM DATE(%s)) = EXTRACT(MONTH FROM DATE(%s))' % (lhs, rhs), params
```
