---
title: Strangler Fig Pattern Explained
date: 2022-01-01 00:00:00
featured_image: https://images.unsplash.com/photo-1493515322954-4fa727e97985
excerpt: Strangler Figs is a nightmare that lives on other tropical trees, stealing their soil nutrients, water, and even sunlight through a canopy of dense leaves and roots that twist around the host plant. Eventually, the fig's roots can completely encase the host, strangling its trunk and cutting off nutrient flow until it dies and rots away leaving just the hollow fig behind.
---

![](https://images.unsplash.com/photo-1493515322954-4fa727e97985)

[Strangler Figs](https://en.wikipedia.org/wiki/Strangler_fig) is a nightmare that lives on other tropical trees, stealing their soil nutrients, water, and even sunlight through a canopy of dense leaves and roots that twist around the host plant. Eventually, the fig's roots can completely encase the host, strangling its trunk and cutting off nutrient flow until it dies and rots away leaving just the hollow fig behind.

Even they are demonised as **brutal killers,** some studies show that strangler figs can be lifesavers of both plants and people. strangler figs may support their hosts during severe storms which contribute to the low death toll of **cyclone pam**.

<iframe width="560" height="315" src="https://www.youtube.com/embed/kVpVbS9CJIk?controls=0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>

**Martin Fowler** inspired by the **strangler fig** and coined the term [Strangler Application](https://martinfowler.com/bliki/StranglerFigApplication.html) as a metaphor in 2004 to describe a way of rewriting important systems or paying of the technical debt.

In a nutshell, the **Strangler Fig Pattern** offers an incremental, reliable process for refactoring code. It describes a method whereby a new system slowly grows over top of an old system until the old system is “strangled” and can simply be removed.

The great thing about this approach is that changes can be incremental, monitored at all times, and the chances of something breaking unexpectedly are fairly low. The old system remains in place until we’re confident that the new system is operating as expected, and then it’s a simple matter of removing all the legacy code.

On the other hand the **waterfall pattern** requires you to commit to a long development and deployment cycle, which increases the risk of bugs and lowers your velocity.

The **waterfall method** can take well over a year to deliver results, but you can make progress in bursts of six months or less by using the more agile **strangler methodology**. It naturally divides work into attainable targets, which means developers are motivated to complete tasks that deliver visible results.

Even there is a lot of **benefits** in adopting the **strangler pattern**, It is worth mentioning that the **strangler pattern** comes with a significant risks too. it adds **some complexity** for teams while developing new features. It can also increase the **technical debt**. if the development teams couldn't finish the **migration plan** for any reason.

There are some guides that worth reading about **monolith refactoring** and **microservices migration** using **strangler pattern**:

- [The End of the Public API Strangler.](https://developers.soundcloud.com/blog/end-of-the-strangler)
- [Refactoring Legacy Code with the Strangler Fig Pattern.](https://shopify.engineering/refactoring-legacy-code-strangler-fig-pattern)
- [Strangler Fig Application.](https://martinfowler.com/bliki/StranglerFigApplication.html)
- [Strangler Fig Pattern.](https://learn.microsoft.com/en-us/azure/architecture/patterns/strangler-fig)
- [Technical Debt Is Like Tetris.](https://medium.com/s/story/technical-debt-is-like-tetris-168f64d8b700)
