// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// This filter reiterates input with an echo density determined by loopDuration.
/// The attenuation rate is independent and is determined by reverbDuration, the
/// reverberation duration (defined as the time in seconds for a signal to decay to 1/1000,
/// or 60dB down from its original amplitude). Output from a comb filter will appear
/// only after loopDuration seconds.
/// 
public class AKCombFilterReverb: AKNode, AKComponent, AKToggleable {

    public static let ComponentDescription = AudioComponentDescription(effect: "comb")

    public typealias AKAudioUnitType = InternalAU

    public private(set) var internalAU: AKAudioUnitType?

    // MARK: - Parameters

    public static let reverbDurationDef = AKNodeParameterDef(
        identifier: "reverbDuration",
        name: "Reverb Duration (Seconds)",
        address: akGetParameterAddress("AKCombFilterReverbParameterReverbDuration"),
        range: 0.0 ... 10.0,
        unit: .seconds,
        flags: .default)

    /// The time in seconds for a signal to decay to 1/1000, or 60dB from its original amplitude. (aka RT-60).
    @Parameter public var reverbDuration: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AKAudioUnitBase {

        public override func getParameterDefs() -> [AKNodeParameterDef] {
            [AKCombFilterReverb.reverbDurationDef]
        }

        public override func createDSP() -> AKDSPRef {
            akCreateDSP("AKCombFilterReverbDSP")
        }

        public func setLoopDuration(_ duration: AUValue) {
            akCombFilterReverbSetLoopDuration(dsp, duration)
        }
    }

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - reverbDuration: The time in seconds for a signal to decay to 1/1000, or 60dB from its original amplitude. (aka RT-60).
    ///   - loopDuration: The loop time of the filter, in seconds. This can also be thought of as the delay time. Determines frequency response curve, loopDuration * sr/2 peaks spaced evenly between 0 and sr/2.
    ///
    public init(
        _ input: AKNode,
        reverbDuration: AUValue = 1.0,
        loopDuration: AUValue = 0.1
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AKAudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            audioUnit.setLoopDuration(loopDuration)

            self.reverbDuration = reverbDuration
        }
        connections.append(input)
    }
}
