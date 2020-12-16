// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;
import "./ds-test/test.sol";

import "./SimpleMerkleProof.sol";

pragma experimental ABIEncoderV2;

contract SimpleMerkleProofTest is DSTest {
    function setUp() public {}

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }

    function testNonCompactMerkleProof1() public view returns (bytes memory) {
        bytes32 root = hex"2a6b9a056f6336ab2417eedcc455a18abd01517c0a4a9adb958699eed84d8b4b";
        bytes[] memory merkleProof = new bytes[](4);
        merkleProof[0] = hex"80490c80b0eadd9230e584b47e00b7cf8e1f927cee0d50485a3c676a11b384ead2bf36ee80bc95ec1b2225e13c653524cb1ff8714173c780ef580581ff66c9604e7fb536c380fda12eddcd0a2e270526fc0037de9da9dcda5c99049e1f74a520c5cbd85db96b8064d657470e1a79e65884b81f1085d11308fd3182d566ffe2b419413ce0495e1980a60aa390511c25e70c1b029d951ef2fd0255b8a3fc3580bed4c4b2fa31789781";
        merkleProof[1] = hex"80fffb80fbd313c51ce7764956f81ef87ff3ebc489b3232cfed8fef9a8434b7414d6f7c880760034d4c3469cab2f0c3c5417980460d295fd8b49cff262a4afb8290c38a57b80150154959b53b033e56db6cb65aa2fedca9dd0071f25eae7ba262841eaf0dbbd807adb48ce7c7686a6b1f726eca635aecf163fcb1ec47f7cacec194be9f340d7b1805c72f25b1b6304d16667e2766fa1a906cb081788eb4502787df7c3597412b17b802d39230527f49cf88fbdd4bf7e3dbcd564218ea2c20751ee4e4e24ecb44989a5800eb754c27d6302344f80fc4f785eae09c7c6acf58ee0ebddbd2f1755eb37a7de806246fab7082d42447ff6a3e4653cb8c2427408eae98af0c40f9c636b972f91548034260342013b628b1a3409a53683bd72866b974fc4bb1e2db0b50c4abd88df0680468f4c745f210c713c8eee6d4bc90e15ac9e708974088d1bf5e01db7fc0781bb809d5adec17d1f91d73f0a631ffe17af9dae7007f69f11bc4d46ca2b9777a921688090e4fe33f4b3a304329c97d1ee3cb8240585cd8c4a1da47f79423a1d91dd1d7180a7a88069a098bb5725ce52c5cf702bed3b1f6f134a69f585d43ab497995fd35280cbcdf9de3ff34d475ef3dad95c4217e6ee4a1e40897550291620d88e1a77c2bd806440a709fcb73133283c13668a87da24982f6b61060d169deb5a43532b553318";
        merkleProof[2] = hex"5f00d41e5e16056765bc8461851072c9d74505240000000000000080e36a09000000000200000001000000000000000000000000000200000002000000000000ca9a3b00000000020000000300000000030e017b1e76c223d1fa5972b6e3706100bb8ddffb0aeafaf0200822520118a87e00000300000003000e017b1e76c223d1fa5972b6e3706100bb8ddffb0aeafaf0200822520118a87ef0a4b9550b000000000000000000000000000300000003020d584a4cbbfd9a4878d816512894e65918e54fae13df39a6f520fc90caea2fb00e017b1e76c223d1fa5972b6e3706100bb8ddffb0aeafaf0200822520118a87ef0a4b9550b00000000000000000000000000030000000e060017640700000000000000000000000000000300000003045a9ae1e0730536617c67ca727de00d4d197eb6afa03ac0b4ecaa097eb87813d6c005d9010000000000000000000000000000030000000000c0769f0b00000000000000";
        merkleProof[3] = hex"9eaa394eea5630e07c48ae0c9558cef7098d585f0a98fdbe9ce6c55837576c60c7af3850100900000080a4adb17d600ad56fb70d03060fc70c9636b53bac26f3d45a525461b3d9fbd8ea80950043f807c1289b7636f6a759abc843caa0f2da40d133ff2fe8821926fd7d93803520a0cde9eee6081349f75cb2771853207aa1b0136c1303677c394d3b2de74880dc4f83e9b8934c4dcffc1d12f846210d0b469982edff3c19c3e89246d9f9b27a705f09cce9c888469bb1a0dceaa129672ef8284820706f6c6b61646f74";

        bytes[] memory keys = new bytes[](1);
        keys[0] = hex"26aa394eea5630e07c48ae0c9558cef780d41e5e16056765bc8461851072c9d7";
        bytes[] memory values = new bytes[](1);
        values[0] = hex"240000000000000080e36a09000000000200000001000000000000000000000000000200000002000000000000ca9a3b00000000020000000300000000030e017b1e76c223d1fa5972b6e3706100bb8ddffb0aeafaf0200822520118a87e00000300000003000e017b1e76c223d1fa5972b6e3706100bb8ddffb0aeafaf0200822520118a87ef0a4b9550b000000000000000000000000000300000003020d584a4cbbfd9a4878d816512894e65918e54fae13df39a6f520fc90caea2fb00e017b1e76c223d1fa5972b6e3706100bb8ddffb0aeafaf0200822520118a87ef0a4b9550b00000000000000000000000000030000000e060017640700000000000000000000000000000300000003045a9ae1e0730536617c67ca727de00d4d197eb6afa03ac0b4ecaa097eb87813d6c005d9010000000000000000000000000000030000000000c0769f0b00000000000000";
        bytes[] memory res = SimpleMerkleProof.verify(root, merkleProof, keys);
        return res[0];
    }

    function testNonCompactMerkleProof2() public view returns (bytes memory) {
        bytes32 root = hex"cf1e37e5cda534181029bd9c576e15e30e21ded185482917e934b2b6b9847be3";
        bytes[] memory merkleProof = new bytes[](4);
        merkleProof[0] = hex"807fb980a854f43152fe7d3212c2575cbfc5252df27f00e353d65db6015feaeb70abb2d280b8fe8690f0c56ad2ef6c67a38cb3ba2766d3e5c278f8fb577e31904f3dc38694805ce2c13476fb588f8eb85329e3ee463602efe9461a96213500fabc25af1bfba4809109739322379c93b150f7b6d7271aa7391d97ced35654bd922dacab0dc8bb7880ec71a12a8008621347d8d6bafe086579bab45704f9e557e25391ed3630c0aced8083fe283f390223d4986264faf72bdbc0e147b52d3967876e0a3b90d589564f5480d7750c197295668e42cd2ce250df7f8f2fd541e95a657d904aa73c12131d151380eb96b92133be69af0b427d0457762cee9836003b9b09e9da247907a7b850f79280bcc74a066b666725b09f4abb0e88a1d345a4775aee2e6d7e8a3b8d1166d88aec805882599c07702a96043f7862f0be599bd2f192b5903720002192ab875d2fec57804144c4c32418317dfe8ac2429fb859dcc924620b2b6dfde736de89331830bf2e8047f80121e40d5d91672bf4d6103d3ce863792b51459139b153ca510de2db20f7";
        merkleProof[1] = hex"9e860dda3d08046cf2706b92bf7202ea120d808d9379a2f152a490b6f4eaf9b3b15dc4fdf5c40db04d1027c096f460f6a8325d80e3c1a4bc53f79d38ece4b23b636d88697deeed63410fc26e85d8baa2d39dde568019e0d8e940b47b8f7e291d08c882bb0ccc4599a1ed5229a9b41403dd57f685c5800eb9fcec237c0c2881b70937f54eb3021da1621a24eb5fa193eb49d2fb08adbf805eebc21f9bf3cb232ed1097ff90a4975f025a5f7d91691639272527c9794e246";
        merkleProof[2] = hex"804501807a7333ff0d7a5b64adff79ebb2a0c4597ffa78c86446ed57175b67aca5918dcb8042ecc1701d89c0574ab923be5da376c04ea0bb25c5c1e09c068ae1db4703fc0b805d5b925d34adcd4a124cb87c80af187dfdcb4a4e2ee3f4789947c62c3950a40880ca08ba0639d8779fbf649860059878a46ebcc3f5d5467ccb01b07f96da40b765";
        merkleProof[3] = hex"5f0e7a79191c90e76297e0895605b8b4577504102403d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27ddac17f958d2ee523a2206206994597c13d831ec700000e5fa31c00000000000000000000002404d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27ddac17f958d2ee523a2206206994597c13d831ec70100e40b5402000000000000000000000024038eaf04151687736326c9fea17e25fc5287613693c912909cb226aa4794f26a48b20bd5d04be54f870d5c0d3ca85d82b34b8364050000d0b72b6a000000000000000000000024048eaf04151687736326c9fea17e25fc5287613693c912909cb226aa4794f26a48b20bd5d04be54f870d5c0d3ca85d82b34b8364050100c817a8040000000000000000000000";

        bytes[] memory keys = new bytes[](1);
        keys[0] = hex"f8860dda3d08046cf2706b92bf7202eaae7a79191c90e76297e0895605b8b457";
        bytes[] memory values = new bytes[](1);
        bytes[] memory res = SimpleMerkleProof.verify(root, merkleProof, keys);
        return res[0];
    }

    function testGetEvents() public view returns (bytes memory) {
        bytes32 root = hex"cf1e37e5cda534181029bd9c576e15e30e21ded185482917e934b2b6b9847be3";
        bytes[] memory merkleProof = new bytes[](4);
        merkleProof[0] = hex"807fb980a854f43152fe7d3212c2575cbfc5252df27f00e353d65db6015feaeb70abb2d280b8fe8690f0c56ad2ef6c67a38cb3ba2766d3e5c278f8fb577e31904f3dc38694805ce2c13476fb588f8eb85329e3ee463602efe9461a96213500fabc25af1bfba4809109739322379c93b150f7b6d7271aa7391d97ced35654bd922dacab0dc8bb7880ec71a12a8008621347d8d6bafe086579bab45704f9e557e25391ed3630c0aced8083fe283f390223d4986264faf72bdbc0e147b52d3967876e0a3b90d589564f5480d7750c197295668e42cd2ce250df7f8f2fd541e95a657d904aa73c12131d151380eb96b92133be69af0b427d0457762cee9836003b9b09e9da247907a7b850f79280bcc74a066b666725b09f4abb0e88a1d345a4775aee2e6d7e8a3b8d1166d88aec805882599c07702a96043f7862f0be599bd2f192b5903720002192ab875d2fec57804144c4c32418317dfe8ac2429fb859dcc924620b2b6dfde736de89331830bf2e8047f80121e40d5d91672bf4d6103d3ce863792b51459139b153ca510de2db20f7";
        merkleProof[1] = hex"9e860dda3d08046cf2706b92bf7202ea120d808d9379a2f152a490b6f4eaf9b3b15dc4fdf5c40db04d1027c096f460f6a8325d80e3c1a4bc53f79d38ece4b23b636d88697deeed63410fc26e85d8baa2d39dde568019e0d8e940b47b8f7e291d08c882bb0ccc4599a1ed5229a9b41403dd57f685c5800eb9fcec237c0c2881b70937f54eb3021da1621a24eb5fa193eb49d2fb08adbf805eebc21f9bf3cb232ed1097ff90a4975f025a5f7d91691639272527c9794e246";
        merkleProof[2] = hex"804501807a7333ff0d7a5b64adff79ebb2a0c4597ffa78c86446ed57175b67aca5918dcb8042ecc1701d89c0574ab923be5da376c04ea0bb25c5c1e09c068ae1db4703fc0b805d5b925d34adcd4a124cb87c80af187dfdcb4a4e2ee3f4789947c62c3950a40880ca08ba0639d8779fbf649860059878a46ebcc3f5d5467ccb01b07f96da40b765";
        merkleProof[3] = hex"5f0e7a79191c90e76297e0895605b8b4577504102403d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27ddac17f958d2ee523a2206206994597c13d831ec700000e5fa31c00000000000000000000002404d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27ddac17f958d2ee523a2206206994597c13d831ec70100e40b5402000000000000000000000024038eaf04151687736326c9fea17e25fc5287613693c912909cb226aa4794f26a48b20bd5d04be54f870d5c0d3ca85d82b34b8364050000d0b72b6a000000000000000000000024048eaf04151687736326c9fea17e25fc5287613693c912909cb226aa4794f26a48b20bd5d04be54f870d5c0d3ca85d82b34b8364050100c817a8040000000000000000000000";

        bytes memory key = hex"f8860dda3d08046cf2706b92bf7202eaae7a79191c90e76297e0895605b8b457";
        bytes memory res = SimpleMerkleProof.getEvents(root, key, merkleProof);
        return res;
    }

    function testGetEvents1() public view returns (bytes memory) {
        bytes32 root = hex"eb3811bb17fe224d59847a47ae0bdd2b2663b1e422c3473638227f86dec82818";
        bytes[] memory merkleProof = new bytes[](4);
        merkleProof[0] = hex"5f0e7a79191c90e76297e0895605b8b4573d02082403d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27df39fd6e51aad88f6f4ce6ab8827279cfffb9226600000e5fa31c00000000000000000000002404d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27df39fd6e51aad88f6f4ce6ab8827279cfffb922660100c817a8040000000000000000000000";
        merkleProof[1] = hex"807fb980b6e1c772a600a844f50a096c8ece7c17ba3897424e9b2c4c628c9dbfbcb67b1180a1cbea221dc71ebd79d899ff50968a589cd5841bdd2bf6ea1eec40e9a02312c88008d8c6bfac6a63ef239d1d263897e322d5f5cff900439d8be2f9ffe536cfc6a780945fd7ca814966d58e83678f656dd4091ea35d8a1264b0555a67a3a27d8a03818038a4dad4200861e593e8d60b8eead8bbe3df94173b1f073eb0049a0371d822808083fe283f390223d4986264faf72bdbc0e147b52d3967876e0a3b90d589564f5480eeeba3be5735ffab390c56824467c3ea8a35bdd3bd267a2dbee0a75013c91d7b80eb96b92133be69af0b427d0457762cee9836003b9b09e9da247907a7b850f79280dbeb12984b545e2760b9cc11bc64c07b5106c5c0504f64e91cdb071081d775f080bd72408dd9809d3ac3875a56e858563a51fd0257d4cefa21486aea4f9ac251a7804144c4c32418317dfe8ac2429fb859dcc924620b2b6dfde736de89331830bf2e8000ad313b9727685624be3c71895bb435eaab6c023ac95938be0381947670d322";
        merkleProof[2] = hex"9e860dda3d08046cf2706b92bf7202ea120d808d9379a2f152a490b6f4eaf9b3b15dc4fdf5c40db04d1027c096f460f6a8325d80e3c1a4bc53f79d38ece4b23b636d88697deeed63410fc26e85d8baa2d39dde568019e0d8e940b47b8f7e291d08c882bb0ccc4599a1ed5229a9b41403dd57f685c58054fa566867bf20c6cad36d14786d19b415f7d99b4592850593168d7aa78cb448805eebc21f9bf3cb232ed1097ff90a4975f025a5f7d91691639272527c9794e246";
        merkleProof[3] = hex"80450180cadab1e024b52fa549e97b73e004a41a66934b4cbd2dcdb8d6074412b5e61eaa8042ecc1701d89c0574ab923be5da376c04ea0bb25c5c1e09c068ae1db4703fc0b80ef50809ca9c02fd313cbf878155b3ee608c543784d0aa5e440a50fd4fe3950ae80b11ce23fad848e1f49ec34917483ecf7aff0ade3295988f94a881f3cd491641f";

        bytes memory key = hex"f8860dda3d08046cf2706b92bf7202eaae7a79191c90e76297e0895605b8b457";
        bytes memory res = SimpleMerkleProof.getEvents(root, key, merkleProof);
        return res;
    }
}
