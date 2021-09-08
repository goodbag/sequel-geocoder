# -*- coding: utf-8 -*-
require 'geocoder/models/active_record'

module Sequel::Plugins::Geocoder
  module ClassMethods
    include ::Geocoder::Model::ActiveRecord

    # Include some of the dataset methods in the model class itself.
    [
      :geocoded,
      :not_geocoded
    ].each do |m|
      define_method(m) { dataset.__send__(m) }
    end

    def near(location, *args)
      dataset.near(location, *args)
    end

    def within_bounding_box(bounds)
      dataset.within_bounding_box(bounds)
    end

    def distance_from_sql(location, *args)
      dataset.distance_from_sql(location, *args)
    end

    private
    # Since sequel 5.0.0 datasets are frozen by default, so
    # the way to set the geocoder options to the dataset is to add them
    # the opts hash.
    def geocoder_init(options)
      new_dataset = dataset.clone(geocoder_options: options)
      self.set_dataset(new_dataset)
    end
  end
end
