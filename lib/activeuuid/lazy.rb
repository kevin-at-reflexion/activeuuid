require 'uuidtools'

class LazyUUID < UUIDTools::UUID
  alias_method :lexical_initialize, :initialize
  def initialize(*args)
    if args.count == 6
      @lazy_initialized = true
      return lexical_initialize(*args)
    elsif args.count != 1
      raise ArgumentError, "wrong number of arguments (#{args.count} for 1)"
    end

    @lazy_initialized = false

    encoded = args.first
    length = encoded.length
    if length == 36
      @string = encoded
    elsif length == 32
      @hexdigest = encoded
    elsif length <= 16
      @raw = encoded.rjust(16, "\0")
    else
      raise ArgumentError, "Expected UUID to be 36, 32, or <= 16 characters, but was #{length}"
    end
  end

  def lazy_initialize
    unless @lazy_initialized
      @lazy_initialized = true

      if @hexdigest
        @time_low = @hexdigest[0...8].to_i(16)
        @time_mid = @hexdigest[8...12].to_i(16)
        @time_hi_and_version = @hexdigest[12...16].to_i(16)
        @clock_seq_hi_and_reserved = @hexdigest[16...18].to_i(16)
        @clock_seq_low = @hexdigest[18...20].to_i(16)

        nodes_hex = @hexdigest[20...32]
        @nodes = (0..5).map { |i| nodes_hex[(i * 2)..(i * 2) + 1].to_i(16) }
      elsif @raw
        raw_bytes = @raw.chars.map(&:ord)
        @time_low = ((raw_bytes[0] << 24) +
                     (raw_bytes[1] << 16) +
                     (raw_bytes[2] << 8)  +
                      raw_bytes[3])
        @time_mid = ((raw_bytes[4] << 8) +
                      raw_bytes[5])
        @time_hi_and_version = ((raw_bytes[6] << 8) +
                                 raw_bytes[7])
        @clock_seq_hi_and_reserved = raw_bytes[8]
        @clock_seq_low = raw_bytes[9]
        @nodes = raw_bytes[10..16]
      else
        uuid_components = @string.downcase.scan(UUIDTools::UUID_REGEXP).first
        raise "Invalid UUID format in lazy initialization of \"#{@string.inspect}\"" if uuid_components.nil?

        @time_low = uuid_components[0].to_i(16)
        @time_mid = uuid_components[1].to_i(16)
        @time_hi_and_version = uuid_components[2].to_i(16)
        @clock_seq_hi_and_reserved = uuid_components[3].to_i(16)
        @clock_seq_low = uuid_components[4].to_i(16)
        @nodes = (0..5).map { |i| uuid_components[5][(i * 2)..(i * 2) + 1].to_i(16) }
      end
    end

    true
  end

  def <=>(other)
    if other.is_a? LazyUUID
      self.raw <=> other.raw
    else
      self.lazy_initialize
      super(other)
    end
  end

  # NOTE(Kevin): Override inspect to be simpler for my debugging; I don't want the object id
  def inspect
    "UUID:#{self}"
  end

  # NOTE(Kevin): Wrap methods which requires us to be initialized
  def generate_s
    @string ? @string : (lazy_initialize and super)
  end

  def freeze
    lazy_initialize
    super
  end

  # NOTE(Kevin): Override accessors which require us to be initialized
  def time_low
    @time_low or (lazy_initialize and @time_low)
  end

  def time_low=(value)
    lazy_initialize unless @time_low
    @time_low = value
  end

  def time_mid
    @time_mid or (lazy_initialize and @time_mid)
  end

  def time_mid=(value)
    lazy_initialize unless @time_mid
    @time_mid = value
  end

  def time_hi_and_version
    @time_hi_and_version or (lazy_initialize and @time_hi_and_version)
  end

  def time_hi_and_version=(value)
    lazy_initialize unless @time_hi_and_version
    @time_hi_and_version = value
  end

  def clock_seq_hi_and_reserved
    @clock_seq_hi_and_reserved or (lazy_initialize and @clock_seq_hi_and_reserved)
  end

  def clock_seq_hi_and_reserved=(value)
    lazy_initialize unless @clock_seq_hi_and_reserved
    @clock_seq_hi_and_reserved = value
  end

  def clock_seq_low
    @clock_seq_low or (lazy_initialize and @clock_seq_low)
  end

  def clock_seq_low=(value)
    lazy_initialize unless @clock_seq_low
    @clock_seq_low = value
  end

  def nodes
    @nodes or (lazy_initialize and @nodes)
  end

  def nodes=(value)
    lazy_initialize unless @nodes
    @nodes = value
  end
end
