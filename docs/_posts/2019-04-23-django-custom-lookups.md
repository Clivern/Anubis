---
title: Django Custom Lookups
date: 2019-04-23 00:00:00
featured_image: https://images.unsplash.com/photo-1534535611235-c7323a5957e9?q=75&fm=jpg&w=1000&fit=max
excerpt: By default Django has a `date` lookup that support timezones. It actually will wrap your field with `CONVERT_TZ` in case `USE_TZ` is `True`. This is pretty awesome unless you have timezones table empty because this call will return `Null.`
---

![](https://images.unsplash.com/photo-1534535611235-c7323a5957e9?q=75&fm=jpg&w=1000&fit=max)

By default Django has a `date` lookup that support timezones. It actually will wrap your field with `CONVERT_TZ` in case `USE_TZ` is `True`. This is pretty awesome unless you have timezones table empty because this call will return `Null.`

```sql
mysql> SELECT CONVERT_TZ('2019-01-01 12:00:00','UTC','UTC');
+-----------------------------------------------+
| CONVERT_TZ('2019-01-01 12:00:00','UTC','UTC') |
+-----------------------------------------------+
| NULL                                          |
+-----------------------------------------------+
1 row in set (0.00 sec)
```

But even the following will work, It is not safe with Daylight saving timing. [You can check this thread](https://code.djangoproject.com/ticket/29384)

```sql
mysql> SELECT CONVERT_TZ('2004-01-01 12:00:00','+00:00','+01:00');
+-----------------------------------------------------+
| CONVERT_TZ('2004-01-01 12:00:00','+00:00','+01:00') |
+-----------------------------------------------------+
| 2004-01-01 13:00:00                                 |
+-----------------------------------------------------+
```

Here is what i was doing

```
import datetime
from django.utils import timezone
from app.models import Incident

days = 1
last_x_days = (timezone.now() - datetime.timedelta(days)).strftime('%Y-%m-%d')
Incident.objects.filter(datetime__date=last_x_days).order_by('-datetime')
```

And this will create an SQL query like this

```
SELECT `app_incident`.`id`, `app_incident`.`name`, `app_incident`.`uri`, `app_incident`.`status`, `app_incident`.`datetime`, `app_incident`.`created_at`, `app_incident`.`updated_at` FROM `app_incident` WHERE DATE(CONVERT_TZ(`app_incident`.`datetime`, 'UTC', 'UTC')) = '2019-04-22' ORDER BY `app_incident`.`datetime` DESC;
```

But the previous SQL Query will never work unless i have timezones table. so I was thinking to make my application work in case timezones table exist or not. so i created another custom lookup that will remove the `CONVERT_TZ` entirely.

```
from django.db.models import Lookup
from django.db.models.fields import DateField, DateTimeField


class DateEqLookup(Lookup):
    """A custom lookup, that lets you query DateField and DateTimeFields by a date"""

    lookup_name = 'date_eq'

    def as_sql(self, compiler, connection):
        lhs, lhs_params = self.process_lhs(compiler, connection)
        rhs, rhs_params = self.process_rhs(compiler, connection)

        params = lhs_params + rhs_params
        return 'DATE(%s) = DATE(%s)' % (lhs, rhs), params

DateField.register_lookup(DateEqLookup)
DateTimeField.register_lookup(DateEqLookup)
```

```
import datetime
from django.utils import timezone
from app.models import Incident

days = 1
last_x_days = (timezone.now() - datetime.timedelta(days))
Incident.objects.filter(datetime__date_eq=last_x_days).order_by('-datetime')
```

and here is the resulting query

```
SELECT `app_incident`.`id`, `app_incident`.`name`, `app_incident`.`uri`, `app_incident`.`status`, `app_incident`.`datetime`, `app_incident`.`created_at`, `app_incident`.`updated_at` FROM `app_incident` WHERE DATE(`app_incident`.`datetime`) = DATE('2019-04-17 20:44:37.697357') ORDER BY `app_incident`.`datetime` DESC;
```

Now i can switch between `__date_eq` and `__date` lookups and the application will always work in case timezone table exists or not.

For more informations about custom lookups [please check django documentations](https://docs.djangoproject.com/en/2.2/howto/custom-lookups/)
