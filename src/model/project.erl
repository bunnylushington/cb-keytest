-module(project, [Id, Name, HackerId]).
-belongs_to(hacker).
-compile(export_all).
