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
        bytes32 root = hex"e09c1c1c7875d75372ae73dcd64fd1822e4eacd2b9be64d7ea8337c4ef2e23eb";
        bytes[] memory merkleProof = new bytes[](4);
        merkleProof[0] = hex"5f0e7a79191c90e76297e0895605b8b457d502082403e44664996ab7b5d86c12e9d5ac3093f5b2efc9172cb7ce298cd6c3c51002c318cc5e48beb33b83b8bd0d9d9a85a8f6a27c51f5c5b52fbe2b925ab79a821b261c82c5ba0814aaa5e000ca9a3b0000000000000000000000002404e44664996ab7b5d86c12e9d5ac3093f5b2efc9172cb7ce298cd6c3c51002c318cc5e48beb33b83b8bd0d9d9a85a8f6a27c51f5c51994100c58753793d52c6f457f189aa3ce9cee9400943577000000000000000000000000";
        merkleProof[1] = hex"807fb9800cca379deda2c66ca282eff02c633b277750f735c1c2d1198af44828bf01198580b44b77690891c0128faf4d9ee8d81715ed44657bad48c8273a042dd8f25fccdd804a4341f0bb1b58fe8e25ceb223f1f17586792485cb9f99dfd9dbcb81377ba9f38091636d63f59f3f8f9a17094ac48bd9c1f6d5dba841c12e2c3e238fd72edacb9b80f4babd9197a9c306f9ae30118f5286a9d0c346d85b8cf357d8aa3f57773218df80b4f78d9f6f42944403dfa6f2953b0f4cf510ffacd019c5575d603930eef0ba7280bcccdb2f043a9d1e0c5f843fb501f6989f1b6ea4b4f91727c0b7db53810a301680eb96b92133be69af0b427d0457762cee9836003b9b09e9da247907a7b850f7928009cd4aa6a8adecefc988c087694cb2c6ac1b447d08b180748548538f56696a89805218fc2e66119cbfbc00e3a63c5dd1d20b727297c98570e09a2edf613fc1e852805fd55f6fcda1c5e18f6d1d55e990b48acc7ea003a557d4627786a9fa35e40a4b803a389213c8df1995f30b8daad839f45db1b353165f5c45371b231889e068f59d";
        merkleProof[2] = hex"80450180df542627f0a7e7f67c545a3466fa38c5b2f2b917bde11ff7d05758849e348bff8042ecc1701d89c0574ab923be5da376c04ea0bb25c5c1e09c068ae1db4703fc0b80757055ee0c9228dbcb23af3cba510cced7b3488b2d2494855f9d7fcf9d7007718084289c2f560c63586df6eeb276eb3de6a7096ef1dba98f7e309161b6e6d04161";
        merkleProof[3] = hex"9e860dda3d08046cf2706b92bf7202ea120f808d9379a2f152a490b6f4eaf9b3b15dc4fdf5c40db04d1027c096f460f6a8325d80e3c1a4bc53f79d38ece4b23b636d88697deeed63410fc26e85d8baa2d39dde568019e0d8e940b47b8f7e291d08c882bb0ccc4599a1ed5229a9b41403dd57f685c580d772acc0bd30338881612d40574a5406652997dec463ac89c6e6f2280193c9ac80a737f1ed41031e1f4f14504fcde03746711e21d389a02913a450ac9ae4136ed1805eebc21f9bf3cb232ed1097ff90a4975f025a5f7d91691639272527c9794e246";

        bytes memory key = hex"f8860dda3d08046cf2706b92bf7202eaae7a79191c90e76297e0895605b8b457";
        bytes memory res = SimpleMerkleProof.getEvents(root, key, merkleProof);
        return res;
    }
}
