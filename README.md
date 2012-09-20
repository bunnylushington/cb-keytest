A small Chicago Boss application to integration test my fork of
boss_db that allows ::uuid IDs.  To run:

  1. download and execute https://raw.github.com/kevinmontuori/cb-keytest/master/priv/setup-keytest-system [*]

  2. cd /var/tmp/cb-uuid-system/keytest
  
  3. ./init-dev.sh

  4. visit http://localhost:8001/maintest

If the test succeeds you'll get a page back with a bunch of "true:"
results.  Any "false:" results indicate an error.  Likewise, some of
the assertions being tested are done with pattern matching in the
controller, so there's that too.  Errors there will crash CB with a
usually helpful error report.  (Hey, it's a hack.)

[*] This test was written to test the pgsql adapter (though one
imagines it could be tweaked for others).  As such it assumes you can
'psql' with no arguments.  Getting that setup is beyond the scope of
the test though check out postgres.app on OS X if you roll that way.

  