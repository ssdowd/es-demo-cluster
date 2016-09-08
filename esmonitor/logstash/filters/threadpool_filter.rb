# encoding: utf-8
# vim filetype=ruby
require "logstash/filters/base"
require "logstash/namespace"

# custom code to break up an event into multiple
class LogStash::Filters::ThreadpoolFilter < LogStash::Filters::Base
  config_name "threadpool_filter"
  config :metadata_name, :validate => :string, :default => "http_poller_metadata", :required => false
  milestone 1

  public
  def register
    # Nothing
  end # def register

  public
  def filter(event)
    return unless filter?(event)
    if event["nodes"].is_a?(Hash)
      event["nodes"].each do |key, val|
        e =  LogStash::Event.new("@timestamp" => event["@timestamp"],
                                 metadata_name => event[metadata_name],
                                 "cluster_name" => event["cluster_name"],
                                 "node_id" => key,
                                 "node" => val["name"])
        val["thread_pool"].each do |k2,v2|
            base = "thread_pool_" + k2
            val["thread_pool"][k2].each do |k3,v3|
                b3 = base + "_" + k3
                e[b3] = v3
            end
        end
        yield e
      end
      event.cancel
    end
  end
end
