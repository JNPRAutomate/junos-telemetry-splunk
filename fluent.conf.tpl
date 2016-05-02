# In v1 configuration, type and id are @ prefix parameters.
# @type and @id are recommended. type and id are still available for backward compatibility

## built-in TCP input
## $ echo <json> | fluent-cat <tag>

<source>
  @type forward
  @id forward_input
</source>

#################
## Input      ###
#################

########## JTI ################
<source>
    @type udp
    tag jnpr.jvision
    format juniper_jti
    port {{ PORT_JTI }}
    bind 0.0.0.0
</source>

########## Analyticsd ################
<source>
    @type udp
    tag jnpr.analyticsd
    format juniper_analyticsd
    port {{ PORT_ANALYTICSD }}
    bind 0.0.0.0
</source>

#################
## Output     ###
#################

# <match jdebug.**>
#     @type stdout
#     @id stdout_output
# </match>

<match jnpr.**>
    type copy
{% if OUTPUT_STDOUT == 'true' %}
    <store>
        @type stdout
        @id stdout_output
    </store>
{% endif %}

    <store>
        ## Add Configuration for Splunk plugin
    </store>

{% endif %}
</match>

# Listen HTTP for monitoring
# http://localhost:24220/api/plugins
# http://localhost:24220/api/plugins?type=TYPE
# http://localhost:24220/api/plugins?tag=MYTAG
<source>
  @type monitor_agent
  @id monitor_agent_input
  port 24220
</source>

# Listen DRb for debug
<source>
  @type debug_agent
  @id debug_agent_input
  bind 127.0.0.1
  port 24230
</source>

## match tag=debug.** and dump to console
<match debug.**>
  @type stdout
  @id stdout_output
</match>

# match fluent's internal events
<match fluent.**>
  @type stdout
</match>
