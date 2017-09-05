module HashStringifyKeys

  refine Hash do
    def stringify_keys
      res = {}

      each_key do |key|
        res[key.to_s] = self[key]
      end

      res
    end
  end

end

module HashSymbolizeKeys

  refine Hash do
    def symbolize_keys
      res = {}

      each_key do |key|
        res[key.to_sym] = self[key]
      end

      res
    end
  end

end

module BlankMethod

  refine String do
    def blank?
      self == ""
    end
  end

  refine NilClass do
    def blank?
      true
    end
  end

  refine Array do
    def blank?
      self == []
    end
  end

  refine Hash do
    def blank?
      self == {}
    end
  end

  refine Symbol do
    def blank?
      self == :''
    end
  end

end
